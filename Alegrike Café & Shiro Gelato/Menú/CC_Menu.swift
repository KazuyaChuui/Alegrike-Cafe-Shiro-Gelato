//
//  CC_Menu.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 4/18/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import Foundation
import UIKit
import FirebaseUI

class CC_Menu: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var category: UILabel!
    
    
    func setup( product: M_Product, imageRef: StorageReference){
        name.text = product.subCategory
        category.text = product.name
        productImage.sd_setImage(with: imageRef)
        
        if product.price == 0{
            if product.name == "Cappuchino Italiano" {
                price.text = "$\(product.size_options_prices[0]!)"
            } else if product.name == "Oficinas y Reuniones"{
                price.text = ""
            } else if product.category == "Malteada" || product.category == "Gelato" || product.category == "Panini"{
                price.text = "$\(product.flavor_options_prices[0]!)-$\(product.flavor_options_prices.last!!)"
            } else {
                price.text = "$\(product.size_options_prices[0]!)-$\(product.size_options_prices.last!!)"
            }
        } else {
            price.text = "$\(product.price)"
        }
    }
    
    
    @IBAction func Add(_ sender: UIButton) {
        
        
    }
    
}
