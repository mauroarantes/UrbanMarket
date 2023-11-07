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
    let title, productDescription: String
    let price: Int
//    let discountPercentage, rating: Double
//    let stock: Int
    let brand, category: String
//    let thumbnail: String
    let images: [String]
    var quantity: Int = 1
    
    private enum CodingKeys: String, CodingKey {
        case id, title, price, brand, category, images
        case productDescription = "description"
    }
}

enum ProductType: String, CaseIterable, Codable {
    case smartphones = "smartphones"
    case laptops = "laptops"
    case groceries = "groceries"
    case homeDecoration = "home-decoration"
    case fragances = "fragrances"
    case skincare = "skincare"
    case furniture = "furniture"
    case tops = "tops"
    case womensDresses = "womens-dresses"
    case womensShoes = "womens-shoes"
    case mensShirts = "mens-shirts"
    case mensShoes = "mens-shoes"
    case mensWatches = "mens-watches"
    case womensWatches = "womens-watches"
    case womensBags = "womens-bags"
    case womensJewellery = "womens-jewellery"
    case sunglasses = "sunglasses"
    case automotive = "automotive"
    case motorcycle = "motorcycle"
    case lighting = "lighting"
}
