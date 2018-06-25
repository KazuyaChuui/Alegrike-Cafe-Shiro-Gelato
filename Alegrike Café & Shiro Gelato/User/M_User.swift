//
//  M_User.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 5/26/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
