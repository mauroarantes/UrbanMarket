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
struct Product: Codable, Identifiable, Hashable {
    let id: Int
    let title, description: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
    let images: [String]
    var quantity: Int = 1
    
    private enum CodingKeys: String, CodingKey {
        case id, title, description, price, discountPercentage, rating, stock, brand, category, thumbnail, images
    }
}

enum ProductType: String, CaseIterable, Codable {
    case smartphones = "smartphones"
    case laptops = "laptops"
    case groceries = "groceries"
    case homeDecoration = "home-decoration"
    case fragances = "fragrances"
    case skincare = "skincare"
}
