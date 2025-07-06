//
//  SignupVC.swift
//  Signupfirebase
//
//  Created by Apple on 05/07/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignupVC: UIViewController {
    
    @IBOutlet weak var userid: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signup(_ sender: Any) {
        
        let userId = userid.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let emailId = email.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let passwordId = password.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

       
        if userId.isEmpty || emailId.isEmpty || passwordId.isEmpty {
            showAlert(title: "Missing Fields", message: "Please fill in all fields.")
            return
        }
        
        
        if passwordId.count < 6 {
            showAlert(title: "Weak Password", message: "Password must be at least 6 characters long.")
            return
        }
        
        
        Auth.auth().createUser(withEmail: emailId, password: passwordId) { authResult, error in
            if let error = error {
                self.showAlert(title: "Signup Failed", message: error.localizedDescription)
                return
            }
            
            guard let uid = authResult?.user.uid else { return }
            
            
            let userData = ["userId": userId, "email": emailId]
            self.databaseRef.child("users").child(uid).setValue(userData)
            
            
            let alert = UIAlertController(title: "Success", message: "Signup Successful!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? UIViewController {
                    homeVC.modalPresentationStyle = .fullScreen
                    self.present(homeVC, animated: true, completion: nil)
                }
            }))
            self.present(alert, animated: true)
        }
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
