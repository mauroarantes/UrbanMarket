//
//  ProductModel.swift
//  Urban Market
//
//  Created by Mauro Arantes on 19/10/2023.
//

import Foundation

// MARK: - ProductModel
struct ProductModel: Codable {
    let products: [Product]
    let total, skip, limit: Int
}

// MARK: - Product
struct Product: Codable, Identifiable {
    let id: Int
    let title, description: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
    let images: [String]
}
