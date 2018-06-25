//
//  VC_Sucursales.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 4/16/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import Firebase

class VC_Sucursales: UIViewController {
    
    @IBOutlet weak var rightButton: UIBarButtonItem!

    let rightButtonDropDown = DropDown()
    var user: User!
    var userMail : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRightBarDropDown()
        rightButtonDropDown.dismissMode = .automatic
        rightButtonDropDown.direction = .bottom
        customizeDropDown(self)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else { return }
            self.user = User(authData: user)
            self.userMail = user.email!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        removeRightLabel()
    }
    
    @IBAction func showBarButtonDropDown(_ sender: AnyObject) {
        rightButtonDropDown.show()
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
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
            "Cerrar Sesión"
        ]
        
        rightButtonDropDown.selectionAction = { [weak self] (index, item) in
            if index == 1 {
                self?.signOut()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yumaya" {
            let vc = segue.destination as! TVC_Menu
            vc.sucursal = "Yumaya"
        } else if segue.identifier == "ipsum" {
            let vc = segue.destination as! TVC_Menu
            vc.sucursal = "Ipsum"
        }
    }
    
}
