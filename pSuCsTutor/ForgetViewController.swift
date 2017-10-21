//
//  ForgetPassWordViewController.swift
//  Find-Tutor
//
//  Created by Thong Tran on 7/27/17.
//  Copyright © 2017 ThongApp. All rights reserved.
//

import UIKit
import FirebaseAuth
class ForgetPassWordViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = " Reset Password"
        // Do any additional setup after loading the view.
    }
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var resetPassWordOutlet: UIButton!
    @IBAction func resetPassWordAction(_ sender: Any) {
        if let email = emailTextField.text {
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
                if error != nil {
                    Utils.display_alert(targetVc: self, title: "Error", message: "Something is going wrong. Please check your email")
                }
            })
        }
    }
    
}
