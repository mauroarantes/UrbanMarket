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
    @Published var fromSearchScreen: Bool = false
    @Published var fromMoreProductsScreen: Bool = false
    @Published var likedProducts: [Product] = []
    @Published var cartProducts: [Product] = []
    
    init() {
        getLikedProducts()
    }
    
    func getLikedProducts() {
        let request = NSFetchRequest<LikedEntity>(entityName: "LikedEntity")
        do {
            CoreDataManager.shared.persistentLikedProducts = try CoreDataManager.shared.context.fetch(request)
            CoreDataManager.shared.persistentLikedProducts.forEach { likedProduct in
                let newProduct = Product(id: Int(likedProduct.id), title: likedProduct.title!, productDescription: likedProduct.productDescription!, price: Int(likedProduct.price), brand: likedProduct.brand!, category: likedProduct.category!, images: [likedProduct.image!])
                likedProducts.append(newProduct)
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
        newLikedProduct.productDescription = product.productDescription
        newLikedProduct.image = product.images[0]
        CoreDataManager.shared.save()
    }
    
    func deleteLikedProduct(id: Int) {
        if let product = CoreDataManager.shared.persistentLikedProducts.first(where: { product in
            product.id == Int16(id)
        }) {
            CoreDataManager.shared.context.delete(product)
            CoreDataManager.shared.save()
        }
    }
    
    func getTotalPrice() -> String {
        var total: Int = 0
        
        cartProducts.forEach { product in
            let productTotal = product.quantity * product.price
            total += productTotal
        }
         return String(format: NSLocalizedString("£%@", comment: "Item price"), "\(total)")
    }
}
