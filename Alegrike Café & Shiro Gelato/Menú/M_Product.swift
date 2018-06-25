//
//  M_Product.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 5/27/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import Foundation
import Firebase

struct M_Product {
    let ref: DatabaseReference?
    let key: String
    let menu: String
    let category: String
    let subCategory: String
    let name: String
    let description: String
    let ima_url: String
    let price: Int
    var multiple_options: [String?]
    var multiple_options_prices: [Int?]
    var single_options: [String?]
    var single_option_prices: [Int?]
    var isAvailable: Bool
    var size_options: [String?]
    var size_options_prices: [Int?]
    var flavor_options: [String?]
    var flavor_options_prices: [Int?]
    
    
    init(){
        self.ref = nil
        self.key = ""
        self.menu = ""
        self.category = ""
        self.subCategory = ""
        self.name = ""
        self.description = ""
        self.ima_url = ""
        self.price = 0
        self.multiple_options = []
        self.multiple_options_prices = []
        self.single_options = []
        self.single_option_prices = []
        self.isAvailable = true
        self.size_options = []
        self.size_options_prices = []
        self.flavor_options = []
        self.flavor_options_prices = []
    }
    
    init?(snapshot: DataSnapshot) {
        
        let value = snapshot.value as? NSDictionary
        let menu = value?["menu"] as? String
        let category = value?["category"] as? String
        let subCategory = value?["subcategory"] as? String
        let name = value?["name"] as? String
        let description = value?["description"] as? String
        let ima_url = value?["ima_url"] as? String
        let price = value?["price"] as? Int ?? 0
        let isAvailable = value?["isAvailable"] as? Bool
        let multiple_options = value?["multiple_options"] as? [String] ?? []
        let multiple_options_prices = value?["multiple_options_prices"] as? [Int] ?? []
        let single_options = value?["single_options"] as? [String] ?? []
        let single_option_prices = value?["single_options_prices"] as? [Int] ?? []
        let size_options = value?["size_options"] as? [String] ?? []
        let size_options_prices = value?["size_options_prices"] as? [Int] ?? []
        let flavor_options = value?["flavor_options"] as? [String] ?? []
        let flavor_options_prices = value?["flavor_options_prices"] as? [Int] ?? []
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.menu = menu!
        self.category = category!
        self.subCategory = subCategory!
        self.name = name!
        self.description = description!
        self.ima_url = ima_url!
        self.price = price
        self.multiple_options = multiple_options
        self.multiple_options_prices = multiple_options_prices
        self.single_options = single_options
        self.single_option_prices = single_option_prices
        self.isAvailable = isAvailable!
        self.size_options = size_options
        self.size_options_prices = size_options_prices
        self.flavor_options = flavor_options
        self.flavor_options_prices = flavor_options_prices
        
    }
    
}
