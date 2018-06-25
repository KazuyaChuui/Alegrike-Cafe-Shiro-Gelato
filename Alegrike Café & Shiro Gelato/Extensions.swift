//
//  Extensions.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 5/26/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

