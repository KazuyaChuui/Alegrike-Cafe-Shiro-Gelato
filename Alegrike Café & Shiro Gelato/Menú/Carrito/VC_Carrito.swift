//
//  VC_Carrito.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 4/16/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import Firebase

class VC_Carrito: UIViewController {
    
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    let rightButtonDropDown = DropDown()
    var ref: DatabaseReference = DatabaseReference()
    var items: [M_Basket] = []
    var sucursal: String = ""
    let user = Auth.auth().currentUser!
    var autoId = ""
    var total: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = productOrder
        tableView.reloadData()
        totalCalculator()
        setupRightBarDropDown()
        setupNavBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showBarButtonDropDown(_ sender: AnyObject) {
        rightButtonDropDown.show()
    }
    
    @IBAction func confirmOrder(_ sender: UIButton){
        let alertVC = UIAlertController(title: "Confirmar Pedido", message: "", preferredStyle: .alert)
        let alert = UIAlertController(title: "Pedido Enviado", message: "", preferredStyle: .alert)
        let alertActionOK = UIAlertAction(title: "Ok", style: .default) {
            (_) in
            self.performSegue(withIdentifier: "unwindToViewController1", sender: self)
        }
        alert.addAction(alertActionOK)
        let alertActionOkay = UIAlertAction(title: "Enviar Pedido", style: .default) {
            (_) in
            //Confirmado
            self.addToFirebase()
            productOrder.removeAll()
            productDict.removeAll()
            self.items.removeAll()
            self.tableView.reloadData()
            self.present(alert, animated: true, completion: nil)
        }
        let alertActionCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alertVC.addAction(alertActionOkay)
        alertVC.addAction(alertActionCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func addToFirebase(){
        let reference = Database.database().reference().child("Basket/\(sucursal)")
        let order = productDict
        let orderRef = reference.childByAutoId()
        orderRef.setValue(order)
        autoId = orderRef.key
    }
    
    func totalCalculator(){
        for obj in items {
            total += obj.price
        }
    }
    
    func customizeDropDown(_ sender: AnyObject) {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
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
    
    func setupNavBar() {
        let rightLabel = UILabel()
        rightLabel.text = "$\(total)"
        rightLabel.textColor = #colorLiteral(red: 0.003404940711, green: 0.5748148561, blue: 0.502276063, alpha: 1)
        rightLabel.font = UIFont.boldSystemFont(ofSize: 34)
        self.navigationController?.navigationBar.addSubview(rightLabel)
        rightLabel.tag = 1
        rightLabel.frame = CGRect(x: self.view.frame.width, y: 0, width: 120, height: 20)
        
        let targetView = self.navigationController?.navigationBar
        
        let trailingContraint = NSLayoutConstraint(item: rightLabel, attribute:
            .trailingMargin, relatedBy: .equal, toItem: targetView,
                             attribute: .trailingMargin, multiplier: 0.9, constant: -16)
        let bottomConstraint = NSLayoutConstraint(item: rightLabel, attribute: .bottom, relatedBy: .equal,
                                                  toItem: targetView, attribute: .bottom, multiplier: 1.0, constant: -6)
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([trailingContraint, bottomConstraint])
        
    }
    
    func removeRightLabel(){
        guard let subviews = self.navigationController?.navigationBar.subviews else{return}
        for view in subviews{
            if view.tag != 0{
                view.removeFromSuperview()
            }
        }
    }
    
    func setupRightBarDropDown() {
        rightButtonDropDown.anchorView = rightButton
        
        rightButtonDropDown.dataSource = [
            "Usuario:\n\(String(describing: Auth.auth().currentUser!.displayName!))",
            "Inicio",
            "Cerrar Sesión"
        ]
        
        rightButtonDropDown.selectionAction = { [weak self] (index, item) in
            if index == 2 {
                self?.signOut()
            } else if index == 1 {
                self?.performSegue(withIdentifier: "unwindToViewController1", sender: self)
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
    
}

// MARK: UITableViewDataSource
extension VC_Carrito: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CarritoCell
        cell.setup(product: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.total -= self.items[indexPath.row].price
            self.items.remove(at: indexPath.row)
            productOrder.remove(at: indexPath.row)
            productDict.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.removeRightLabel()
            self.setupNavBar()
        }
    }
}

