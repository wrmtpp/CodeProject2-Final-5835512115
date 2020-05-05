//
//  LoginViewController.swift
//  StartupStore
//
//  Created by Woramet Prompen on 2019-07-22.
//  Copyright © 2019 Woramet Prompen. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setUpElements()
    }
    
    func setUpElements() {
        
        // ซ่อนแถบ Error
        errorLabel.alpha = 0
        
        // รูปแบบของช่องข้อมูล
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        
    }
    
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        
        // การเข้าสูู่สมาชิก
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // เก็บ email pass
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // ถ้าเข้าไม่ได้
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                let viewControllerMain = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.viewControllerMain) as? ViewControllerMain
                
                self.view.window?.rootViewController = viewControllerMain
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
}
