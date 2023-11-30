//
//  People.swift
//  FriendFace
//
//  Created by SCOTT CROWDER on 11/30/23.
//

import Foundation

struct People: Codable, Identifiable {
    var id: String
    var name: String
    var address: String
    var email: String
    var age: Int
    var company: String
    var about: String
}

struct Tags: Codable {
    var tag: String
}

struct Friends: Codable {
    var id: String
    var name: String
}
