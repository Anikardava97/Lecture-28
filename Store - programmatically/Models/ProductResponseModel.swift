//
//  ProductResponseModel.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import Foundation

struct ProductResponseModel: Decodable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Product: Decodable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    var stock: Int
    let category: String
    let thumbnail: String
    let images: [String]
    
    var selectedAmount: Int?
}




