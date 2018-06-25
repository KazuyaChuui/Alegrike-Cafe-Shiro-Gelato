//
//  TC_Carrito.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 4/18/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import Foundation
import UIKit

class CarritoCell: UITableViewCell {
    
    @IBOutlet weak var nameFInal: UILabel!
    @IBOutlet weak var priceFinal: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    
    func setup(product: M_Basket){
        self.nameFInal.text = product.category
        self.priceFinal.text = "$\(product.price)"
        self.descripcion.text = "\(product.name)    Options: \(product.options ?? "")        Other: \(product.size ?? "")        Extra: \(product.extra ?? "")\n\nCantidad: \(product.quantity)"
    }
}
