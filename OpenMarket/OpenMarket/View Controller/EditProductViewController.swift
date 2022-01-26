//
//  PostProductViewController.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/21.
//

import UIKit

class EditProductViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var postImageListCollectionView: UICollectionView!
    @IBOutlet weak var postImageButton: UIButton!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var currencySwitchController: UISegmentedControl!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var productStockTextField: UITextField!
    @IBOutlet weak var productNavigationBar: UINavigationItem!
    @IBOutlet weak var productDescription: UITextView!
    let imagePickerController = UIImagePickerController()
    let alertController = UIAlertController(title: "사진 추가", message: nil, preferredStyle: .actionSheet)
    var tempPostImage: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerController.delegate = self
        placeholderSetting()
        addImageAlert()
        
        postImageListCollectionView.delegate = self
        postImageListCollectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        postImageListCollectionView.collectionViewLayout = flowLayout
        postImageListCollectionView.isPagingEnabled = true
    }
    
    @IBAction func hitCancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hitDoneButton(_ sender: Any) {
        let paramData: [String:String] = ["name" : productNameTextField.text ?? "",
                                          "price" : productPriceTextField.text ?? "",
                                          "discountedPrice" : discountedPriceTextField.text ?? "0",
                                          "stock" : productStockTextField.text ?? "0",
                                          "description" : productDescription.text ?? ""]
        
        var postDataManager = PostDataManager(segmentedControllerIndex: currencySwitchController.selectedSegmentIndex,
                                              postPramData: paramData,
                                              tempPostImage: tempPostImage)
        postDataManager.saveImages()
        if postDataManager.imagesIsEmpty {
            nilImageAlert()
            return
        }
        postDataManager.saveData()
        postDataManager.requestData()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hitPostImageButton(_ sender: Any) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func placeholderSetting() {
        productNameTextField.delegate = self
        productPriceTextField.delegate = self
        discountedPriceTextField.delegate = self
        productStockTextField.delegate = self
        productNameTextField.placeholder = "상품명"
        productPriceTextField.placeholder = "상품가격"
        discountedPriceTextField.placeholder = "할인금액"
        productStockTextField.placeholder = "재고수량"
    }
    
    func addImageAlert() {
        let photoLibraryAlert = UIAlertAction(title: "사진앨범", style: .default) { _ in
            self.openAlbum()
        }
        let cancelAlert = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        self.alertController.addAction(photoLibraryAlert)
        self.alertController.addAction(cancelAlert)
    }
    
    func openAlbum() {
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.allowsEditing = true
        present(self.imagePickerController, animated: false, completion: nil)
    }
    
    func nilImageAlert() {
        let nilImageAlert = UIAlertController(title: "사진이 첨부되지 않았습니다.", message: "1장이상 5장이하의 사진을 추가해주세요.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        nilImageAlert.addAction(okAction)
        present(nilImageAlert, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editProductView = segue.destination as? EditProductViewController {
            editProductView.productNavigationBar.title = "상품수정"
        }
    }
}

extension EditProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = image
        }
        tempPostImage.append(newImage ?? UIImage())
        postImageListCollectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempPostImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as? ProductImageCell else {
            return ProductImageCell()
        }
        
        cell.previewImageView.image = tempPostImage[indexPath.item]
        
        return cell
    }
    
}

extension EditProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
