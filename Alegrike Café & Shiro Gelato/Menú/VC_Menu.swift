//
//  VC_Menu.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 4/16/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import DropDown

class VC_Menu: UIViewController {
    
    lazy var storageRef: StorageReference = Storage.storage().reference(forURL: "gs://alegrike-cafe.appspot.com/Products")
    
    var items = [M_Product]()
    var filtered = [M_Product]()
    var sucursal: String = ""
    var categoryType: String = ""
    let reuseIdentifier = "menuCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 2
    
    @IBOutlet weak var collectionViewMenu: UICollectionView!
    
    @IBOutlet weak var rightButton: UIBarButtonItem!
    let rightButtonDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        presentView()
        setupRightBarDropDown()
        sucursal = (items[0].ref?.parent?.key)!
        rightButtonDropDown.dismissMode = .automatic
        rightButtonDropDown.direction = .bottom
        customizeDropDown(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeRightLabel()
    }

    @IBAction func showBarButtonDropDown(_ sender: AnyObject) {
        rightButtonDropDown.show()
    }
    
    func presentView() {
        if categoryType == "single"{
            filtered = items
        } else {
            filtered = items.filter { $0.category == categoryType }
        }
        self.collectionViewMenu.reloadData()
    }
    
    func customizeDropDown(_ sender: AnyObject) {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        //        appearance.textFont = UIFont(name: "Georgia", size: 14)
        
            rightButtonDropDown.cellNib = UINib(nibName: "DropDownCell",  bundle: Bundle(for: DropDownCell.self))
            
            rightButtonDropDown.customCellConfiguration = nil
    }
    
    func setupRightBarDropDown() {
        rightButtonDropDown.anchorView = rightButton
        
        rightButtonDropDown.dataSource = [
            "Usuario:\n\(String(describing: Auth.auth().currentUser!.displayName!))",
            "Inicio",
            "Canasta",
            "Cerrar Sesión"
        ]
        
        rightButtonDropDown.selectionAction = { [weak self] (index, item) in
            if index == 1 {
                self?.performSegue(withIdentifier: "unwindToViewController1", sender: self)
            } else if index == 3 {
                self?.signOut()
            } else if index == 2{
                self?.performSegue(withIdentifier: "canastaSegue", sender: index)
            }
        }
    }
    
    func signOut() {
        let user = Auth.auth().currentUser!
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
        
        onlineRef.removeValue { (error, _) in
            if let error = error {
                print("Removing online failed: \(error)")
                return
            }
            
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "inicio", sender: self)
            } catch (let error) {
                print("Auth sign out failed: \(error)")
            }
        }
    }
    
    
    func removeRightLabel(){
        guard let subviews = self.navigationController?.navigationBar.subviews else{return}
        for view in subviews{
            if view.tag != 0{
                view.removeFromSuperview()
            }
        }
    }
    
    
    
}

// MARK: UICollectionView DataSource
extension VC_Menu: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CC_Menu
        var category = filtered[indexPath.row].name
        let replacements = ["ñ" : "n", "é" : "e", "ó":"o", "í":"i"]
        replacements.keys.forEach { category = category.replacingOccurrences(of: $0, with: replacements[$0]!)}
        let imageRef = storageRef.child("\(category).png")
        cell.setup(product: filtered[indexPath.row], imageRef: imageRef)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let vc = segue.destination as! VC_Detail
            let index = (sender as! NSIndexPath)
            vc.setup(product: filtered[index.row])
        } else if segue.identifier == "account" {
            
        } else if segue.identifier == "basket" {
            
        } else if segue.identifier == "canastaSegue" {
            let vc = segue.destination as! VC_Carrito
            vc.sucursal = sucursal
        }
    }
}

extension VC_Menu: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionViewMenu.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
