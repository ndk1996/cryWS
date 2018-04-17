//
//  Coin.swift
//  cryptocurrency
//
//  Created by Khoa Nguyen on 4/2/18.
//  Copyright © 2018 KhoaNguyen. All rights reserved.
//

import Foundation

struct Coin : Decodable{
    let available_supply : String!
    let last_values : LastValue?
    let name : String!
    let symbol : String!
    
}

