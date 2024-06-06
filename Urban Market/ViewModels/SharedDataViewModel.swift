//
//  SharedDataViewModel.swift
//  Urban Market
//
//  Created by Mauro Arantes on 26/10/2023.
//

import Foundation
import CoreData

class SharedDataViewModel: ObservableObject {
    @Published var detailProduct: Product?
    @Published var showDetailProduct: Bool = false
    @Published var screen: Screen = .Home
    @Published var likedProducts: [Product] = []
    @Published var cartProducts: [Product] = []
    
    init() {
        getLikedProducts()
        getCartProducts()
    }
    
    func getCartProducts() {
        let request = NSFetchRequest<CartEntity>(entityName: "CartEntity")
        do {
            CoreDataManager.shared.persistentCartProducts = try CoreDataManager.shared.context.fetch(request)
            CoreDataManager.shared.persistentCartProducts.forEach { cartProduct in
                if let title = cartProduct.title, let description = cartProduct.productDescription, let brand = cartProduct.brand, let category = cartProduct.category, let image = cartProduct.image {
                    let newProduct = Product(id: Int(cartProduct.id), title: title, description: description, price: Double(cartProduct.price), brand: brand, category: category, images: [image])
                    cartProducts.append(newProduct)
                }
            }
        } catch let error {
            print("Error fetching Core Data: \(error.localizedDescription)")
        }
    }
    
    func addCartProduct(product: Product) {
        let newCartProduct = CartEntity(context: CoreDataManager.shared.context)
        newCartProduct.id = Int16(product.id)
        newCartProduct.title = product.title
        newCartProduct.brand = product.brand
        newCartProduct.price = Int16(product.price)
        newCartProduct.category = product.category
        newCartProduct.productDescription = product.description
        newCartProduct.image = product.images[0]
        CoreDataManager.shared.save()
    }
    
    func deleteCartProduct(id: Int) {
        let request = NSFetchRequest<CartEntity>(entityName: "CartEntity")
        do {
            CoreDataManager.shared.persistentCartProducts = try CoreDataManager.shared.context.fetch(request)
        } catch {
            print("Error fetching Core Data: \(error.localizedDescription)")
        }
        if let product = CoreDataManager.shared.persistentCartProducts.first(where: { product in
            product.id == Int16(id)
        }) {
            CoreDataManager.shared.context.delete(product)
            CoreDataManager.shared.save()
        }
    }
    
    func getLikedProducts() {
        let request = NSFetchRequest<LikedEntity>(entityName: "LikedEntity")
        do {
            CoreDataManager.shared.persistentLikedProducts = try CoreDataManager.shared.context.fetch(request)
            CoreDataManager.shared.persistentLikedProducts.forEach { likedProduct in
                if let title = likedProduct.title, let description = likedProduct.productDescription, let brand = likedProduct.brand, let category = likedProduct.category, let image = likedProduct.image {
                    let newProduct = Product(id: Int(likedProduct.id), title: title, description: description, price: Double(likedProduct.price), brand: brand, category: category, images: [image])
                    likedProducts.append(newProduct)
                }
            }
        } catch let error {
            print("Error fetching Core Data: \(error.localizedDescription)")
        }
    }
    
    func addLikedProduct(product: Product) {
        let newLikedProduct = LikedEntity(context: CoreDataManager.shared.context)
        newLikedProduct.id = Int16(product.id)
        newLikedProduct.title = product.title
        newLikedProduct.brand = product.brand
        newLikedProduct.price = Int16(product.price)
        newLikedProduct.category = product.category
        newLikedProduct.productDescription = product.description
        newLikedProduct.image = product.images[0]
        CoreDataManager.shared.save()
    }
    
    func deleteLikedProduct(id: Int) {
        let request = NSFetchRequest<LikedEntity>(entityName: "LikedEntity")
        do {
            CoreDataManager.shared.persistentLikedProducts = try CoreDataManager.shared.context.fetch(request)
        } catch {
            print("Error fetching Core Data: \(error.localizedDescription)")
        }
        if let product = CoreDataManager.shared.persistentLikedProducts.first(where: { product in
            product.id == Int16(id)
        }) {
            CoreDataManager.shared.context.delete(product)
            CoreDataManager.shared.save()
        }
    }
    
    func getTotalPrice() -> String {
        var total: Double = 0
        
        cartProducts.forEach { product in
            let productTotal = Double(product.quantity) * product.price
            total += productTotal
        }
         return String(format: NSLocalizedString("£%@", comment: "Item price"), "\(total)")
    }
}
