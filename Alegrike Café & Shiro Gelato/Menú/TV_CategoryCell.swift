//
//  TV_CategoryCell.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 6/2/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class TV_CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setup(name: String, imageRef: StorageReference, color: UIColor) {
        categoryName.text = name
        categoryImage.backgroundColor = color
        productImage.sd_setImage(with: imageRef)
        let maskLayer = CAGradientLayer()
        maskLayer.frame = productImage.bounds
        maskLayer.shadowRadius = 5
        maskLayer.shadowPath = CGPath(roundedRect: productImage.bounds.insetBy(dx: 5, dy: 5), cornerWidth: 10, cornerHeight: 10, transform: nil)
        maskLayer.shadowOpacity = 1
        maskLayer.shadowOffset = CGSize.zero
        maskLayer.shadowColor = UIColor.white.cgColor
        productImage.layer.mask = maskLayer
    }
}
