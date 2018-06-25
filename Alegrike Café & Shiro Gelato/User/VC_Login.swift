//
//  VC_Login.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 4/16/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class VC_Login: UIViewController {
    
    let identifier = "menuView"
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTap()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil && (user?.isEmailVerified)!{
                self.performSegue(withIdentifier: self.identifier, sender: nil)
                self.email.text = nil
                self.pass.text = nil
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func prepareForLogin(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func loginDidTouch(_ sender: UIButton) {
        guard
            let mail = email.text,
            let password = pass.text,
            mail.count > 0,
            password.count > 0
        else {
            return
        }
        
        Auth.auth().signIn(withEmail: mail, password: password) { (user, error) in
            if let user = Auth.auth().currentUser {
                if !user.isEmailVerified{
                    let alertVC = UIAlertController(title: "Error", message: "Lo lamentamos. Su direccion de correo electronico no a sido verificada. Desea que enviemos de nuevo la verificacion a \(String(describing: self.email.text!)).", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "De acuerdo", style: .default) {
                        (_) in
                        user.sendEmailVerification(completion: nil)
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
                    
                    alertVC.addAction(alertActionOkay)
                    alertVC.addAction(alertActionCancel)
                    self.present(alertVC, animated: true, completion: nil)
                } else {
                    print ("Email verified. Signing in...")
                    self.performSegue(withIdentifier: self.identifier, sender: nil)
                    self.email.text = nil
                    self.pass.text = nil
                }
            }
        }
    }
}
