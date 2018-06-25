//
//  H_CollectionReusableView.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 5/28/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import Foundation
import UIKit

class H_CollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleHeader: UILabel!
    
    func setup( product: M_Product){
        self.titleHeader.text = product.menu
    }
    
}
