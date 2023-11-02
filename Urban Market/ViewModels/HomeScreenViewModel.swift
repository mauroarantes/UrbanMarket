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
    var searchCancellable: AnyCancellable?
    
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var productType: ProductType = .smartphones
    @Published var showMoreProducts = false
    @Published var searchText = ""
    @Published var searchActive = false
    @Published var searchedProducts: [Product]?
    
    init() {
        getProducts()
        searchCancellable = $searchText.removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str != "" {
                    self.filterProductsBySearch()
                } else {
                    self.searchedProducts = nil
                }
            })
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
                self?.filterProductsByType()
            }
            .store(in: &cancellables)

    }
    
    func filterProductsByType() {
        DispatchQueue.global(qos: .userInteractive).async {
            let results = self.products
                .lazy
                .filter { product in
                    product.category == self.productType.rawValue
                }
            DispatchQueue.main.async {
                self.filteredProducts = results.compactMap({ product in
                    product
                })
            }
        }
    }
    
    func filterProductsBySearch() {
        DispatchQueue.global(qos: .userInteractive).async {
            let results = self.products
                .lazy
                .filter { product in
                    product.title.lowercased().contains(self.searchText.lowercased())
                }
            DispatchQueue.main.async {
                self.searchedProducts = results.compactMap({ product in
                    product
                })
            }
        }
    }
}
