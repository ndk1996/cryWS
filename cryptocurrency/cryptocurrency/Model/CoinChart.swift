//
//  CoinChart.swift
//  cryptocurrency
//
//  Created by Khoa Nguyen on 4/10/18.
//  Copyright © 2018 KhoaNguyen. All rights reserved.
//

import Foundation

struct CoinChart : Decodable{
    var index:Int?
    let available_supply : String!
    let max7days_values : Max7daysValues?
    let name : String!
    let symbol : String!
    
}

struct Max7daysValues : Decodable{
    let prev0 : LastValue?
    let prev1 : LastValue?
    let prev2 : LastValue?
    let prev3 : LastValue?
    let prev4 : LastValue?
    let prev5 : LastValue?
    let prev6 : LastValue?
    let prev7 : LastValue?
}

struct LastValue : Decodable{
    let marketcap : Int?
    let price : Float?
    let timeStamp : Int?
    let volume24 : String?
    let change_1h: String?
    let change_24h: String?
    
}
