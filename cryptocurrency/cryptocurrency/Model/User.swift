//
//  User.swift
//  cryptocurrency
//
//  Created by Khoa Nguyen on 4/17/18.
//  Copyright © 2018 KhoaNguyen. All rights reserved.
//

import Foundation

struct User: Codable {
    var favorites: [String]
    let _id, username, password, rule: String
    
}
