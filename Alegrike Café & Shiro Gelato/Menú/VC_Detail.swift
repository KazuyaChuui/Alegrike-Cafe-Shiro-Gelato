//
//  VC_Detail.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 5/29/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import UIKit
import Firebase
import DropDown
import FirebaseUI

class VC_Detail: UIViewController {

    var product: M_Product = M_Product()
    
    lazy var storageRef: StorageReference = Storage.storage().reference(forURL: "gs://alegrike-cafe.appspot.com/Products")

    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var descriptionProduct: UILabel!
    @IBOutlet weak var quantityBtn: UIButton!
    @IBOutlet weak var sizeBtn: UIButton!
    @IBOutlet weak var milkBtn: UIButton!
    @IBOutlet weak var baseBtn: UIButton!
    @IBOutlet weak var categoryProduct: UILabel!
    
    @IBOutlet weak var qLabel: UILabel!
    @IBOutlet weak var sLabel: UILabel!
    @IBOutlet weak var mLabel: UILabel!
    @IBOutlet weak var bLabel: UILabel!
    
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    let rightButtonDropDown = DropDown()
    let quantityDropDown = DropDown()
    let sizeDropDown = DropDown()
    let milkDropDown = DropDown()
    let baseDropDown = DropDown()
    
    let model = Prices()
    let user = Auth.auth().currentUser!
    
    var observers = [NSKeyValueObservation]()
    var size: String = ""
    var optionals: String = ""
    var extra: String = ""
    var autoId = ""
    var total = 0
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.quantityDropDown,
            self.baseDropDown,
            self.sizeDropDown,
            self.milkDropDown,
            self.rightButtonDropDown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = product.name
        
        let imageRef = storageRef.child("\(product.name).png")
        imageProduct.sd_setImage(with: imageRef)
        setupDropdowns()
        nameProduct.text = product.subCategory
        descriptionProduct.text = product.description
        categoryProduct.text = product.name
        haveOptions()
        priceCalculator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        qLabel.isHidden = true
        bLabel.isHidden = true
        mLabel.isHidden = true
        sLabel.isHidden = true
        removeRightLabel()
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        addtoCartArray()
        let vc = storyboard?.instantiateViewController(withIdentifier: "canasta") as! VC_Carrito
        vc.ref = (product.ref?.database.reference())!
        vc.sucursal = (product.ref?.parent?.key)!
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func quantityAction(_ sender: UIButton) {
        quantityDropDown.show()
    }
    
    @IBAction func sizeAction(_ sender: UIButton) {
        sizeDropDown.show()
    }
    
    @IBAction func milkAction(_ sender: UIButton) {
        milkDropDown.show()
    }
    
    @IBAction func baseAction(_ sender: UIButton) {
        baseDropDown.show()
    }
    
    @IBAction func showBarButtonDropDown(_ sender: AnyObject) {
        rightButtonDropDown.show()
    }
    
    func addtoCartArray(){
        let email = user.email!
        var components = email.components(separatedBy: "@")
        let mail = components.removeFirst()
        total = (self.product.price + model.sizePrice + model.extraPrice + model.milkPrice) * model.quantityPrice
        productDict.append(M_Basket(name: product.name, category: product.category, price: total, quantity: model.quantityPrice, size: size, options: optionals, extra: extra, user: user.displayName!, mail: mail, email: email, isClosed: false).toAnyObject())
        productOrder.append(M_Basket(name: product.name, category: product.category, price: total, quantity: model.quantityPrice, size: size, options: optionals, extra: extra, user: user.displayName!, mail: mail, email: email, isClosed: false))
        
    }
    
    func removeRightLabel(){
        guard let subviews = self.navigationController?.navigationBar.subviews else{return}
        for view in subviews{
            if view.tag != 0{
                view.removeFromSuperview()
            }
        }
    }
    
    func priceCalculator() {
        if product.price != 0 {
            priceProduct.text = "$\(product.price)"
        }
        if product.category == "Frappe Alegrike" || product.category == "Cappuchino Frappe"{
            priceProduct.text = "$\(product.price)"
            self.observers = [
                model.observe(\.sizePrice, changeHandler: { (model, change) in
                    self.priceProduct.text = "$\((self.product.price + model.sizePrice + model.extraPrice + model.milkPrice) * model.quantityPrice)"
                }),
                model.observe(\.extraPrice, changeHandler: { (model, change) in
                    self.priceProduct.text = "$\((self.product.price + model.sizePrice + model.extraPrice + model.milkPrice) * model.quantityPrice)"
                }),
                model.observe(\.milkPrice, changeHandler: { (model, change) in
                    self.priceProduct.text = "$\((self.product.price + model.sizePrice + model.extraPrice + model.milkPrice) * model.quantityPrice)"
                }),
                model.observe(\.quantityPrice, changeHandler: { (model, change) in
                    self.priceProduct.text = "$\((self.product.price + model.sizePrice + model.extraPrice + model.milkPrice) * model.quantityPrice)"
                })
            ]
        } else if !product.size_options_prices.isEmpty {
            priceProduct.text = "$\(product.size_options_prices[0]!)"
            self.observers = [
                model.observe(\.sizePrice, changeHandler: { (model, change) in
                    self.priceProduct.text = "$\((self.product.price + model.sizePrice + model.extraPrice + model.milkPrice) * model.quantityPrice)"
                }),
                model.observe(\.extraPrice, changeHandler: { (model, change) in
                    self.priceProduct.text = "$\((self.product.price + model.sizePrice + model.extraPrice + model.milkPrice) * model.quantityPrice)"
                }),
                model.observe(\.milkPrice, changeHandler: { (model, change) in
                    self.priceProduct.text = "$\((self.product.price + model.sizePrice + model.extraPrice + model.milkPrice) * model.quantityPrice)"
                }),
                model.observe(\.quantityPrice, changeHandler: { (model, change) in
                    self.priceProduct.text = "$\((self.product.price + model.sizePrice + model.extraPrice + model.milkPrice) * model.quantityPrice)"
                })
            ]
        } else {
            priceProduct.text = "$\(product.price)"
            self.observers = [
                model.observe(\.sizePrice, changeHandler: { (model, change) in
                    self.priceProduct.text = "$\((self.product.price + model.sizePrice + model.extraPrice + model.milkPrice) * model.quantityPrice)"
                }),
                model.observe(\.extraPrice, changeHandler: { (model, change) in
                    self.priceProduct.text = "$\((self.product.price + model.sizePrice + model.extraPrice + model.milkPrice) * model.quantityPrice)"
                }),
                model.observe(\.milkPrice, changeHandler: { (model, change) in
                    self.priceProduct.text = "$\((self.product.price + model.sizePrice + model.extraPrice + model.milkPrice) * model.quantityPrice)"
                }),
                model.observe(\.quantityPrice, changeHandler: { (model, change) in
                    self.priceProduct.text = "$\((self.product.price + model.sizePrice + model.extraPrice + model.milkPrice) * model.quantityPrice)"
                })
            ]
        }
        
    }
    
    func haveOptions() {
        haveSize()
        haveMilk()
        haveExtras()
        haveQuantity()
    }
    
    func haveQuantity() {
        if product.name == "Oficinas y Reuniones" {
            qLabel.isHidden = true
            quantityBtn.isHidden = true
        }
    }
    
    func haveSize() {
        if !product.size_options.isEmpty || product.category == "Gelato" || product.category == "Malteada" || product.category == "Panini" || product.category == "Frappe Alegrike" || product.category == "Cappuchino Frappe"{
            sizeBtn.isHidden = false
            setupSizeDropDown()
        } else {
            sizeBtn.isHidden = true
            sLabel.isHidden = true
        }
        
    }
    
    func haveExtras() {
        if !product.multiple_options.isEmpty && product.category != "Cappuchino Frappe"{
            baseBtn.isHidden = false
            setupBaseDropDown()
        } else {
            baseBtn.isHidden = true
            bLabel.isHidden = true
        }
    }
    
    func haveMilk() {
        if !product.single_options.isEmpty && product.category != "Frappe Alegrike"{
            milkBtn.isHidden = false
            setupMilkDropDown()
        } else {
            milkBtn.isHidden = true
            mLabel.isHidden = true
        }
    }
    
    func setup( product: M_Product ){
        self.product = product
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
        
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "DropDownCell",  bundle: Bundle(for: DropDownCell.self))
            
            $0.customCellConfiguration = nil
        }
    }
    
    func setupDropdowns() {
        dropDowns.forEach { $0.dismissMode = .automatic }
        dropDowns.forEach { $0.direction = .bottom }
        customizeDropDown(self)
        setupBaseDropDown()
        setupMilkDropDown()
        setupQuantityDropDown()
        setupRightBarDropDown()
    }
    
    func setupQuantityDropDown() {
        quantityDropDown.anchorView = quantityBtn
        
        
        quantityDropDown.bottomOffset = CGPoint(x: 0, y: quantityBtn.bounds.height)
        
        quantityDropDown.dataSource = [
            "1",
            "2",
            "3",
            "4",
            "5"
        ]
        
        // Action triggered on selection
        quantityDropDown.selectionAction = { [weak self] (index, item) in
            self?.qLabel.isHidden = false
            self?.model.quantityPrice = Int(item)!
            self?.quantityBtn.setTitle(item, for: .normal)
        }
    }
    func setupSizeDropDown() {
        sizeDropDown.anchorView = sizeBtn
        
        sizeDropDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        
        sizeDropDown.bottomOffset = CGPoint(x: 0, y: sizeBtn.bounds.height)
        
        if product.category == "Gelato" || product.category == "Malteada" || product.category == "Panini"{
            sLabel.text = "Sabores:"
            sizeBtn.setTitle("Sabores⌄", for: .normal)
            sizeDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? MyCell else { return }
                cell.priceLabel.text = "$\(self.product.flavor_options_prices[index]!)"
            }
            sizeDropDown.dataSource = product.flavor_options as! [String]
            
        } else if product.category == "Frappe Alegrike"{
            sLabel.text = "Base:"
            sizeBtn.setTitle("Base⌄", for: .normal)
            sizeDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? MyCell else { return }
                cell.priceLabel.text = "$\(self.product.single_option_prices[index]!)"
            }
            sizeDropDown.dataSource = product.single_options as! [String]
            
        } else if product.category == "Cappuchino Frappe"{
            sLabel.text = "Extras:"
            sizeBtn.setTitle("Extras⌄", for: .normal)
            sizeDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? MyCell else { return }
                cell.priceLabel.text = "+$\(self.product.multiple_options_prices[index]!)"
            }
            sizeDropDown.dataSource = product.multiple_options as! [String]
            
        } else {
            sizeDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? MyCell else { return }
                cell.priceLabel.text = "$\(self.product.size_options_prices[index]!)"
            }
            sizeDropDown.dataSource = product.size_options as! [String]
        }
        
        sizeDropDown.selectionAction = { [weak self] (index, item) in
            self?.sLabel.isHidden = false
            if self?.product.category == "Gelato" || self?.product.category == "Malteada" || self?.product.category == "Panini"{
                self?.model.sizePrice = (self?.product.flavor_options_prices[index])!
            } else if self?.product.category == "Frappe Alegrike"{
                self?.model.sizePrice = (self?.product.single_option_prices[index])!
            } else  if self?.product.category == "Cappuchino Frappe"{
                self?.model.sizePrice = (self?.product.multiple_options_prices[index])!
            } else{
                self?.model.sizePrice = (self?.product.size_options_prices[index])!
            }
            self?.sizeBtn.setTitle(item, for: .normal)
            self?.size = item
        }
    }
    func setupMilkDropDown() {
        milkDropDown.anchorView = milkBtn
        
        milkDropDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        
        milkDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            cell.priceLabel.text = "+$\(self.product.single_option_prices[index]!)"
        }
        
        milkDropDown.bottomOffset = CGPoint(x: 0, y: milkBtn.bounds.height)
        
        milkDropDown.dataSource = product.single_options as! [String]
        
        // Action triggered on selection
        milkDropDown.selectionAction = { [weak self] (index, item) in
            self?.mLabel.isHidden = false
            self?.model.milkPrice = (self?.product.single_option_prices[index])!
            self?.milkBtn.setTitle(item, for: .normal)
            self?.optionals = item
        }
    }
    func setupBaseDropDown() {
        baseDropDown.anchorView = baseBtn
        
        baseDropDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        
        baseDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            cell.priceLabel.text = "+$\(self.product.multiple_options_prices[index]!)"
        }
        
        baseDropDown.bottomOffset = CGPoint(x: 0, y: baseBtn.bounds.height)
        
        baseDropDown.dataSource = product.multiple_options as! [String]
        
        // Action triggered on selection
        baseDropDown.selectionAction = { [weak self] (index, item) in
            self?.bLabel.isHidden = false
            self?.model.extraPrice = (self?.product.multiple_options_prices[index])!
            self?.baseBtn.setTitle(item, for: .normal)
            self?.extra = item
        }
    }
    
    func setupRightBarDropDown() {
        rightButtonDropDown.anchorView = rightButton
        
        rightButtonDropDown.dataSource = [
            "Usuario:\n\(String(describing: user.displayName!))",
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class Prices: NSObject {
    @objc dynamic var sizePrice = 0
    @objc dynamic var extraPrice = 0
    @objc dynamic var quantityPrice = 1
    @objc dynamic var milkPrice = 0
}
