//
//  ViewController.swift
//  Signupfirebase
//
//  Created by Apple on 04/07/25.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func signup(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signupVC = storyboard.instantiateViewController(withIdentifier: "SignupVC") as? SignupVC {
            self.navigationController?.pushViewController(signupVC, animated: true)
        }
    }


    
    @IBAction func login(_ sender: Any) {
        guard let emailText = email.text, !emailText.isEmpty,
              let passwordText = password.text, !passwordText.isEmpty else {
            showAlert(title: "Error", message: "Please enter both email and password.")
            return
        }

        Auth.auth().signIn(withEmail: emailText, password: passwordText) { authResult, error in
            if let error = error {
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
            } else {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }
            }
        }
    }

    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
