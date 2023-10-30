//
//  SharedDataViewModel.swift
//  Urban Market
//
//  Created by Mauro Arantes on 26/10/2023.
//

import Foundation

class SharedDataViewModel: ObservableObject {
    @Published var detailProduct: Product?
    @Published var showDetailProduct: Bool = false
    @Published var fromSearchScreen: Bool = false
    @Published var likedProducts: [Product] = []
    @Published var cartProducts: [Product] = []
    
}
