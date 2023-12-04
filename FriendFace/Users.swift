//
//  People.swift
//  FriendFace
//
//  Created by SCOTT CROWDER on 11/30/23.
//

import Foundation
import SwiftData

struct Users: Codable, Identifiable {
    var id: String
    var name: String
    var address: String
    var email: String
    var age: Int
    var company: String
    var about: String
    var tags: [String]
    var isActive: Bool
    var registered: Date
    var friends: [Friends]?
    
    var unwrappedFriends: [Friends] {
        friends ?? []
    }
}

struct Tags: Codable {
    enum CodingKeys: String, CodingKey {
        case tag = "tags"
    }
    
    var tag: String
}

struct Friends: Codable, Identifiable {
    var id: String
    var name: String
}
