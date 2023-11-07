//
//  UserModel.swift
//  Urban Market
//
//  Created by Mauro Arantes on 25/10/2023.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: String
    var fullName: String
    var email: String
    var password: String
}

extension User {
    static let MOCK_USER = User(id: NSUUID().uuidString, fullName: "Elizeth Cardoso", email: "divina@gmail.com", password: "")
}
