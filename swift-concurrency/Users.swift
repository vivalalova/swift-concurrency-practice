//
//  Users.swift
//  Users
//
//  Created by Lova on 2021/8/6.
//

import SwiftUI

struct User: Codable, Identifiable {
    struct Location: Codable {
        var lat: String
        var lng: String
    }

    struct Address: Codable {
        var street: String
        var suite: String
        var city: String
        var zipcode: String
        var geo: Location
    }

    struct Company: Codable {
        var name: String
        var catchPhrase: String
        var bs: String
    }

    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address
    var phone: String
    var website: String
    var company: Company
}
