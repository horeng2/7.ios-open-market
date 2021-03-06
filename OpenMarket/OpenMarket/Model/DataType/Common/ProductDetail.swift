//
//  Product.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/03.
//

import Foundation

struct ProductDetail: Codable {
    let productNumber: Int
    let vendorNumber: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let images: [Image]
    let vendors: Vendor
    let createdAt: Date
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case productNumber = "id"
        case vendorNumber = "vendor_id"
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case images
        case vendors
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
