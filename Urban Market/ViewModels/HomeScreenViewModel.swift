//
//  HomeScreenViewModel.swift
//  Urban Market
//
//  Created by Mauro Arantes on 19/10/2023.
//

import Foundation
import Combine

class HomeScreenViewModel: ObservableObject {
    
    var cancellables = Set<AnyCancellable>()
    @Published var products: [Product] = []
    
    init() {
        getProducts()
    }
    
    func getProducts() {
        
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: ProductModel.self, decoder: JSONDecoder())
            .sink { completion in
                print("COMPLETION: \(completion)")
            } receiveValue: { [weak self] productModel in
                self?.products = productModel.products
            }
            .store(in: &cancellables)

    }
}
