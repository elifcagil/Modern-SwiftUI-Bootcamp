//
//  User.swift
//  SwiftUIForm
//
//  Created by Kadir Aktaş on 8.09.2025.
//

import Foundation

enum City: String, CaseIterable, Identifiable {
    case adana = "Adana"
    case istanbul = "İstanbul"
    case izmir = "İzmir"
    case other = "Diğer"

    var id:String {self.rawValue}
    var displayName:String {self.rawValue}
}


struct User: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var email: String
    var city: City
    var password: String
    var age: Int
    var agreeToTerms: Bool
    var wantsNewsletter: Bool

    init(
        name: String = "",
        email: String = "",
        password: String = "",
        age: Int = 18,
        city: City = .istanbul,
        agreeToTerms: Bool = false,
        wantsNewsletter: Bool = false
    ) {
        self.name = name
        self.email = email
        self.password = password
        self.age = age
        self.city = city
        self.agreeToTerms = agreeToTerms
        self.wantsNewsletter = wantsNewsletter
    }
}
