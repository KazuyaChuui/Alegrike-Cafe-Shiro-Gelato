//
//  M_Basket.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 6/12/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import Foundation
import Firebase

struct M_Basket {
    let ref: DatabaseReference?
    let key: String
    let name: String
    let category: String
    let price: Int
    let quantity: Int
    let size: String?
    let options: String?
    let extra: String?
    let user: String
    let mail: String
    let email: String
    let isClosed: Bool
    
    init(key: String = "", name: String, category: String, price: Int, quantity: Int, size: String, options: String, extra: String, user: String, mail: String,email: String, isClosed: Bool) {
        self.ref = nil
        self.key = key
        self.name = name
        self.category = category
        self.price = price
        self.quantity = quantity
        self.size = size
        self.options = options
        self.extra = extra
        self.user = user
        self.mail = mail
        self.email = email
        self.isClosed = isClosed
    }
    
    init?(snapshot: DataSnapshot) {
        let value = snapshot.value as? NSDictionary
        let name = value?["name"] as? String
        let category = value?["category"] as? String
        let price = value?["price"] as? Int
        let quantity = value?["quantity"] as? Int
        let size = value?["size"] as? String ?? ""
        let options = value?["options"] as? String ?? ""
        let extra = value?["extra"] as? String ?? ""
        let user = value?["user"] as? String
        let mail = value?["mail"] as? String
        let email = value?["email"] as? String
        let isClosed = value?["isClosed"] as? Bool
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name!
        self.category = category!
        self.price = price!
        self.quantity = quantity!
        self.size = size
        self.options = options
        self.extra = extra
        self.user = user!
        self.mail = mail!
        self.email = email!
        self.isClosed = isClosed!
    }
    
    func toAnyObject() -> [String : Any] {
        var dict = [String : Any]()
        dict["name"] = name
        dict["category"] = category
        dict["price"] = price
        dict["quantity"] = quantity
        dict["size"] = size ?? ""
        dict["options"] = options ?? ""
        dict["extra"] = extra ?? ""
        dict["user"] = user
        dict["mail"] = mail
        dict["email"] = email
        dict["isClosed"] = isClosed
        
        return dict
    }
    
}
