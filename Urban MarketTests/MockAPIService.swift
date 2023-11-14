//
//  MockAPIService.swift
//  Urban MarketTests
//
//  Created by Mauro Arantes on 13/11/2023.
//

import Foundation
import Combine
@testable import Urban_Market

class MockAPIService: APIServiceProtocol {
    
    let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func getProducts(url: URL) -> AnyPublisher<ProductModel, Error> {
        if let path = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ProductModel.self, from: data)
                return Just(jsonData)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                print("error:\(error)")
                return Fail(error: NetworkError.dataNotFound)
                    .eraseToAnyPublisher()
            }
        }
        return Fail(error: NSError())
            .eraseToAnyPublisher()
    }
}
