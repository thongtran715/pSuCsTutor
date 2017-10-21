//
//  SignUpViewController.swift
//  Find-Tutor
//
//  Created by Thong Tran on 7/27/17.
//  Copyright © 2017 ThongApp. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class SignUpViewController: UIViewController {
    
    
    override func viewDidLoad() {
        // Making the rounded circle Profile Image
        self.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelecImageGesture)))
        self.profileImage.isUserInteractionEnabled = true
        super.viewDidLoad()
        firstNameTextField.delegate = self
        firstNameTextField.tag = 0
        lastNameTextField.delegate = self
        lastNameTextField.tag = 1
        emailTextField.delegate = self
        emailTextField.tag = 2
        passWordTextField.delegate = self
        passWordTextField.tag = 3
    }
    // MARK -->  TextField Variables
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var passWordTextField: UITextField!
    
    
    
    @IBAction func SignInButton(_ sender: Any) {
        if let email = emailTextField.text, let password = passWordTextField.text, let first_name = firstNameTextField.text, let last_name = lastNameTextField.text {
            FIRAuth.auth()?.createUser(withEmail: email,  password: password, completion: { (user, error) in
                
                // Check if the uid is existed
                guard let uid = user?.uid else {
                    return
                }
                
                // Upload data to Firebase
                let imageName_to_Storage = NSUUID().uuidString
                let storageRef = FIRStorage.storage().reference().child("Profile_Images").child("\(imageName_to_Storage).png")
                
                if let uploadData = UIImageJPEGRepresentation(self.profileImage.image!, 0.1){
                    
                    storageRef.put(uploadData, metadata: nil, completion: { (medata, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        if let imageURL = medata?.downloadURL()?.absoluteString {
                            let values = ["First Name": first_name, "Last Name": last_name, "Email" : email, "ProfileImageURL":imageURL, "Rating " : 0 ] as [String : Any]
                            
                            self.registerUserWithId(uid: uid, values: values as [String : AnyObject])
                        }
                        
                        
                        
                    })
                    
                }
                
                
            })
        }
    }
    // Hide the keyboard by tapping anywhere
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}





// This extends the Textfield Delegate
extension SignUpViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            
            nextField.becomeFirstResponder()
            
        } else {
            
            textField.resignFirstResponder()
            
            return true;
            
        }
        
        return false
        
    }
}









extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func registerUserWithId ( uid: String , values : [String : AnyObject])
    {
        // Get the URL to store data
        let ref = FIRDatabase.database().reference(fromURL: "https://find-tutor-c094e.firebaseio.com/")
        // Get the Path called Users
        let UsersPathReference = ref.child("Tutors")
        // Get the Path called unique data
        let UsersWithUniqueIdReference = UsersPathReference.child(uid)
        UsersWithUniqueIdReference.updateChildValues(values) { (error, ref) in
            if let error = error {
                Utils.display_alert(targetVc: self, title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    // Making action Sheet View Controller
    func picture_alert_action_sheet ()
    {
        let alertActionSheet = UIAlertController(title: nil, message: "Take Picture From", preferredStyle:.actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
        }
        let library = UIAlertAction(title: "Library", style: .default) { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertActionSheet.addAction(camera)
        alertActionSheet.addAction(library)
        alertActionSheet.addAction(cancel)
        self.present(alertActionSheet, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image_temp : UIImage?
        if let orignialImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            image_temp = orignialImage
        }
        else if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            image_temp = editedImage
        }
        if let image = image_temp {
            self.profileImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func handleSelecImageGesture() {
        picture_alert_action_sheet()
    }
    
    
    
}


