//
//  ViewController.swift
//  MeetnRun
//
//  Created by ALugo on 29/7/22.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    @IBAction func clickSignUpProfessional(_ sender: Any) {
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let secondVC = storyboard.instantiateViewController(identifier: "SignProfessionalController")
               
               secondVC.modalPresentationStyle = .fullScreen
               secondVC.modalTransitionStyle = .crossDissolve
               
               present(secondVC, animated: true, completion: nil)
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        
        if !usernameTextField.hasText || !passwordTextField.hasText {
            let alert = AlertHandler.getWarningEmptyFields()
            self.present(alert, animated: true, completion: nil)
        } else {
            
            let uc = UserController()
            let username = usernameTextField.text!
            
            guard let expectedUser = uc?.getUser(username) else {
                let alert = AlertHandler.getErrorIncorrectUsernamePassword()
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let password = passwordTextField.text!
            if expectedUser.password != password {
                let alert = AlertHandler.getErrorIncorrectUsernamePassword()
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            UserDefaultsManager.login(expectedUser.username!)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondVC = storyboard.instantiateViewController(identifier: "HomeNavController")
            
            secondVC.modalPresentationStyle = .fullScreen
            secondVC.modalTransitionStyle = .crossDissolve
            
            present(secondVC, animated: true, completion: nil)
        }
    }
}

