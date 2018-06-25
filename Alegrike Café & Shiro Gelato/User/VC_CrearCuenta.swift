//
//  VC_CrearCuenta.swift
//  Alegrike Café & Shiro Gelato
//
//  Created by Jesus Ruiz on 4/18/18.
//  Copyright © 2018 AkibaTeaParty. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class VC_CrearCuenta: UIViewController {
    
    let identifier = "menuView"
    var accepted: Bool = false
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var passConfirm: UITextField!
    @IBOutlet weak var confirmed: UILabel!
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTap()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: self.identifier, sender: nil)
                self.email.text = nil
                self.pass.text = nil
                self.passConfirm.text = nil
                self.username.text = nil
            }
        }
        
        passConfirm.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func confirmPassword() -> Bool {
        if pass.text == passConfirm.text {
            return true
        }
        return false
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        if pass.text == passConfirm.text {
            confirmed.text = "✓"
            confirmed.textColor = .green
        }else{
            confirmed.text = "✗"
            confirmed.textColor = .red
        }

    }
    
    @IBAction func createUserButton(_ sender: UIButton) {
        guard
            let mail = email.text,
            let password = pass.text,
            let confirm = passConfirm.text,
            let username = username.text,
            mail.count > 0,
            password.count > 0,
            confirm.count > 0,
            username.count > 0
            else {
                return
        }
        
        if confirmPassword() && accepted{
            Auth.auth().createUser(withEmail: mail, password: password) { user, error in
                if error == nil {
                    Auth.auth().signIn(withEmail: mail, password: password)
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let changeRequest = user.createProfileChangeRequest()
                        
                        changeRequest.displayName = username
                        changeRequest.commitChanges { error in
                            if let error = error {
                                // An error happened.
                            } else {
                                // Profile updated.
                            }
                        }
                    }
                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                    
                }
            }
        } else {
            print("pass not match or terms are not accepted")
        }
    }
    
    
    
    @IBAction func confirmTerm(_ sender: UIButton) {
        if accepted == true {
            sender.setTitle("", for: .normal)
            accepted = false
        } else {
            sender.setTitle("✓", for: .normal)
            accepted = true
        }
    }
    
    
}
