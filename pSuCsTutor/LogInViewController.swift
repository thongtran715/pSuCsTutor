//
//  LogInViewController.swift
//  Find-Tutor
//
//  Created by Thong Tran on 7/27/17.
//  Copyright © 2017 ThongApp. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.red
        if FIRAuth.auth()?.currentUser != nil {
            let mainStoryBoadViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainStoryBoard")
            self.navigationController?.present(mainStoryBoadViewController!, animated: true, completion: nil)
        }
        
    }
    @IBOutlet var LoginOutlet: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passWordTextField: UITextField!
    @IBAction func LogInButton(_ sender: Any) {
        if let email = emailTextField.text, let password = passWordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                
                // Indiciate the Activity Indicatator to load the Image
                let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
                myActivityIndicator.center = self.view.center
                myActivityIndicator.color = UIColor.red
                myActivityIndicator.hidesWhenStopped = false
                myActivityIndicator.startAnimating()
                
                // Something is wrong
                if let error = error {
                    Utils.display_alert(targetVc: self, title: "Error", message: error.localizedDescription)
                    return
                }
                let mainStoryBoadViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainStoryBoard")
                self.navigationController?.present(mainStoryBoadViewController!, animated: true, completion: nil)
                myActivityIndicator.stopAnimating()
                self.view.addSubview(myActivityIndicator)
            })
        }
    }
    
    
    
}
