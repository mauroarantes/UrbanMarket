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
    let price: Double
    let brand: String?
    let category: String
    let images: [String]
    var quantity: Int = 1
    
    private enum CodingKeys: String, CodingKey {
        case id, title, description, price, brand, category, images
    }
}

enum ProductType: String, CaseIterable, Codable {
    case smartphones = "smartphones"
    case mobileAccessories = "mobile-accessories"
    case laptops = "laptops"
    case tablets = "tablets"
    case groceries = "groceries"
    case homeDecoration = "home-decoration"
    case beauty = "beauty"
    case fragances = "fragrances"
    case skinCare = "skin-care"
    case furniture = "furniture"
    case tops = "tops"
    case womensDresses = "womens-dresses"
    case womensShoes = "womens-shoes"
    case mensShirts = "mens-shirts"
    case mensShoes = "mens-shoes"
    case mensWatches = "mens-watches"
    case sportsAccessories = "sports-accessories"
    case womensWatches = "womens-watches"
    case womensBags = "womens-bags"
    case womensJewellery = "womens-jewellery"
    case sunglasses = "sunglasses"
    case automotive = "vehicle"
    case motorcycle = "motorcycle"
    case kitchenAccessories = "kitchen-accessories"
}
