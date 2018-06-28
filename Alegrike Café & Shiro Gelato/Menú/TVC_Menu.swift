//
//  TVC_Menu.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 5/28/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import UIKit
import Firebase
import DropDown

class TVC_Menu: UITableViewController {

    let ref = Database.database()
    var items: [M_Product] = []
    var sucursal: String = ""
    let menu = ["Caliente", "Frio", "Comida", "Extras"]
    let background = [ #imageLiteral(resourceName: "Caliente.jpg"), #imageLiteral(resourceName: "Frio.jpg"), #imageLiteral(resourceName: "Comida.jpg"), #imageLiteral(resourceName: "Extras.jpg")]
    @IBOutlet weak var rightButton: UIBarButtonItem!
    let rightButtonDropDown = DropDown()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        initializeQueryProduct()
        setupRightBarDropDown()
        rightButtonDropDown.dismissMode = .automatic
        rightButtonDropDown.direction = .bottom
        customizeDropDown(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        removeRightLabel()
    }

    @IBAction func showBarButtonDropDown(_ sender: AnyObject) {
        rightButtonDropDown.show()
    }
    
    func initializeQueryProduct() {
        let menu = ref.reference(withPath: sucursal)
        var newItems: [M_Product] = []
        let query = menu.queryOrdered(byChild: "menu")
        query.observe(.value, with: { snapshot in
            newItems.removeAll()
            for childSnapshot in snapshot.children {
                if let snapshot = childSnapshot as? DataSnapshot,
                    let product = M_Product(snapshot: snapshot){
                    newItems.append(product)
                }
            }
            self.items.removeAll()
            self.items = newItems.filter { $0.isAvailable == true }
        })
        
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
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tHeight = tableView.bounds.height - (self.navigationController?.navigationBar.frame.size.height)! - UIApplication.shared.statusBarFrame.height - view.safeAreaInsets.bottom
        let temp = tHeight/4
        return temp > 100 ? temp : 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuType", for: indexPath) as! TV_MenuCell
        cell.setup(name: menu[indexPath.row], image: background[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 || indexPath.row == 3 {
            self.performSegue(withIdentifier: "categorySegue", sender: indexPath)
        } else {
            self.performSegue(withIdentifier: "menuSegue", sender: indexPath)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuSegue" {
            let vc = segue.destination as! TVC_Category
            let index = (sender as! NSIndexPath)
            vc.menuType = menu[index.row]
            vc.notFiltered = items
        } else if segue.identifier == "categorySegue" {
            let vc = segue.destination as! VC_Menu
            let index = (sender as! NSIndexPath)
            if index.row == 2 {
                vc.items = items.filter { $0.menu == "Comida" }
                vc.categoryType = "single"
            }else {
                vc.items = items.filter { $0.menu == "Extras" }
                vc.categoryType = "single"
            }
        } else if segue.identifier == "canastaSegue" {
            let vc = segue.destination as! VC_Carrito
            vc.sucursal = sucursal
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */



}
