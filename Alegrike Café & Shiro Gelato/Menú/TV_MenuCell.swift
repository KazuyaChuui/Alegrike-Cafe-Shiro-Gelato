//
//  TV_MenuCell.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 5/29/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import UIKit

class TV_MenuCell: UITableViewCell {

    
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var imageMenu: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(name: String, image: UIImage) {
        menuName.text = name
        imageMenu.image = image
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        tintView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        imageMenu.addSubview(tintView)
    }

}
