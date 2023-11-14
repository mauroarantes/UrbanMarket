//
//  NetwrokError.swift
//  Urban Market
//
//  Created by Mauro Arantes on 13/11/2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case parsingError
    case dataNotFound
    case responseError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self{
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "invalidURL")
        case .parsingError:
            return NSLocalizedString("Parsing Error", comment: "parsingError")
        case .dataNotFound:
            return NSLocalizedString("DataNot Found", comment: "dataNotFound")
        case .responseError:
            return NSLocalizedString("response Error", comment: "responseError")
        }
    }
}
