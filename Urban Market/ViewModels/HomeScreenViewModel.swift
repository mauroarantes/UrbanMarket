//
//  HomeScreenViewModel.swift
//  Urban Market
//
//  Created by Mauro Arantes on 19/10/2023.
//

import Foundation
import Combine

class HomeScreenViewModel: ObservableObject {
    //testCommentTony
    var apiService: APIServiceProtocol
    var cancellables = Set<AnyCancellable>()
    var searchCancellable: AnyCancellable?
    
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var productType: ProductType = .smartphones
    @Published var showMoreProducts = false
    @Published var searchText = ""
    @Published var searchActive = false
    @Published var searchedProducts: [Product]?
    @Published var customError: NetworkError?
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
        apiCall()
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
    
    func apiCall() {
        
        guard let url = URL(string: "https://dummyjson.com/products/?limit=0") else {
            self.customError = NetworkError.invalidURL
            return
        }
        
        apiService.getProducts(url: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink { completion in
                switch completion{
                case .failure(let error):
                    switch error {
                    case is URLError:
                        self.customError = NetworkError.invalidURL
                    case NetworkError.dataNotFound:
                        self.customError = NetworkError.dataNotFound
                    case NetworkError.parsingError:
                        self.customError = NetworkError.parsingError
                    default:
                        self.customError = NetworkError.dataNotFound
                    }
                case .finished:
                    print("COMPLETION: \(completion)")
                }
            } receiveValue: { [weak self] (productModel: ProductModel) in
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
//extension Product {
//    convenience init?(_ product: RawProduct?) {
//        guard let id = product?.id,
//              let title = product?.title,
//              let description = product?.description,
//              let price = product?.price,
//              let category = product?.category,
//              let images = product?.images else {
//            return nil
//        }
//        self.init(id: id, title: title, description: description, price: price, brand: product?.brand ?? "UAI3", category: category, images: images)
//    }
//}
