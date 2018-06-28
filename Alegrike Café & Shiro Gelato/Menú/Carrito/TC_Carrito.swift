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
        if (product.options == "" || product.size == "" || product.extra == "") {
            if (product.size == "") {
                self.descripcion.text = "\(product.name)\nOpciones: \(product.options ?? "")\nExtra: \(product.extra ?? "")\nCantidad: \(product.quantity)"
                if (product.extra == "") {
                    self.descripcion.text = "\(product.name)\nOpciones: \(product.options ?? "")\nCantidad: \(product.quantity)"
                    if (product.options == ""){
                        self.descripcion.text = "\(product.name)\nCantidad: \(product.quantity)"
                    }
                } else if (product.options == ""){
                    self.descripcion.text = "\(product.name)\nOtro: \(product.size ?? "")\nExtra: \(product.extra ?? "")\nCantidad: \(product.quantity)"
                }
            } else if (product.extra == "") {
                self.descripcion.text = "\(product.name)\nOpciones: \(product.options ?? "")\nDetalle: \(product.size ?? "")\nCantidad: \(product.quantity)"
                if (product.options == ""){
                    self.descripcion.text = "\(product.name)\nCantidad: \(product.quantity)"
                } 
            } else if (product.options == ""){
                self.descripcion.text = "\(product.name)\nDetalle: \(product.size ?? "")\nExtra: \(product.extra ?? "")\nCantidad: \(product.quantity)"
            } else {
                self.descripcion.text = "\(product.name)\nCantidad: \(product.quantity)"
            }
        } else if (product.options != "" && product.size != "" && product.extra != ""){
            self.descripcion.text = "\(product.name)\nOpciones: \(product.options ?? "")\nDetalle: \(product.size ?? "")\nExtra: \(product.extra ?? "")\nCantidad: \(product.quantity)"
        }
    }
}
