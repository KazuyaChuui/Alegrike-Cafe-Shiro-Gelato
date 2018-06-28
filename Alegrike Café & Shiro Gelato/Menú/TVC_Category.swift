//
//  TVC_Category.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 6/2/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import UIKit
import DropDown
import Firebase
import Photos

class TVC_Category: UITableViewController {
    
    lazy var storageRef: StorageReference = Storage.storage().reference(forURL: "gs://alegrike-cafe.appspot.com/")
    
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    var items: [M_Product] = []
    var notFiltered: [M_Product] = []
    let rightButtonDropDown = DropDown()
    var menuType: String = ""
    var categories: [String] = [String]()
    var sucursal: String = ""
    let colorsHot: [UIColor] = [#colorLiteral(red: 0.9294117647, green: 0.8666666667, blue: 0.6588235294, alpha: 1),#colorLiteral(red: 0.8588235294, green: 0.7176470588, blue: 0.5490196078, alpha: 1),#colorLiteral(red: 0.9294117647, green: 0.8666666667, blue: 0.6588235294, alpha: 1),#colorLiteral(red: 0.8588235294, green: 0.7176470588, blue: 0.5490196078, alpha: 1),#colorLiteral(red: 0.9294117647, green: 0.8666666667, blue: 0.6588235294, alpha: 1),#colorLiteral(red: 0.8588235294, green: 0.7176470588, blue: 0.5490196078, alpha: 1),#colorLiteral(red: 0.9294117647, green: 0.8666666667, blue: 0.6588235294, alpha: 1),#colorLiteral(red: 0.8588235294, green: 0.7176470588, blue: 0.5490196078, alpha: 1),#colorLiteral(red: 0.9294117647, green: 0.8666666667, blue: 0.6588235294, alpha: 1),#colorLiteral(red: 0.8588235294, green: 0.7176470588, blue: 0.5490196078, alpha: 1)]
    let colorsCold: [UIColor] = [#colorLiteral(red: 0.9843137255, green: 0.7450980392, blue: 0.8274509804, alpha: 1),#colorLiteral(red: 0.7529411765, green: 0.9333333333, blue: 0.8078431373, alpha: 1),#colorLiteral(red: 0.968627451, green: 0.9215686275, blue: 0.6901960784, alpha: 1),#colorLiteral(red: 0.9490196078, green: 0.7490196078, blue: 0.4901960784, alpha: 1),#colorLiteral(red: 0.6117647059, green: 0.3803921569, blue: 0.262745098, alpha: 1),#colorLiteral(red: 0.9843137255, green: 0.7450980392, blue: 0.8274509804, alpha: 1),#colorLiteral(red: 0.7529411765, green: 0.9333333333, blue: 0.8078431373, alpha: 1),#colorLiteral(red: 0.968627451, green: 0.9215686275, blue: 0.6901960784, alpha: 1),#colorLiteral(red: 0.9490196078, green: 0.7490196078, blue: 0.4901960784, alpha: 1),#colorLiteral(red: 0.6117647059, green: 0.3803921569, blue: 0.262745098, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menú \(menuType)"
        categoryCount()
        setupRightBarDropDown()
        sucursal = (items[0].ref?.parent?.key)!
        rightButtonDropDown.dismissMode = .automatic
        rightButtonDropDown.direction = .bottom
        customizeDropDown(self)
    }
    
    @IBAction func showBarButtonDropDown(_ sender: AnyObject) {
        rightButtonDropDown.show()
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
    
    func categoryCount() {
        items = notFiltered.filter { $0.menu == menuType }
        categories = items.map { $0.category }
        categories.removeDuplicates()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let minHeight:CGFloat = 100
        let tHeight = tableView.bounds.height - (self.navigationController?.navigationBar.frame.size.height)! - UIApplication.shared.statusBarFrame.height - view.safeAreaInsets.bottom
        let temp = tHeight/CGFloat(categories.count)
        return temp > minHeight ? temp : minHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! TV_CategoryCell
        let imageRef: StorageReference
        if categories[indexPath.row] == "Café Americano" {
            imageRef = storageRef.child("Americano.jpg")
        } else {
            imageRef = storageRef.child("\(categories[indexPath.row]).jpg")
        }

        if menuType == "Caliente" {
            cell.setup(name: categories[indexPath.row], imageRef: imageRef,color: colorsHot[indexPath.row])
        } else if menuType == "Frio"{
            cell.setup(name: categories[indexPath.row], imageRef: imageRef,color: colorsCold[indexPath.row])
        } else {
            cell.setup(name: categories[indexPath.row], imageRef: imageRef,color: .white)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "categorySegue", sender: indexPath)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categorySegue" {
            let vc = segue.destination as! VC_Menu
            let index = (sender as! NSIndexPath)
            vc.items = items
            vc.categoryType = categories[index.row]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}
