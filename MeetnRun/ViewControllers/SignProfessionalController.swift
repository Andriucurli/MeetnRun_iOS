//
//  SignProfessionalController.swift
//  MeetnRun
//
//  Created by ALugo on 29/7/22.
//

import UIKit

class SignProfessionalController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    let uc = UserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        repeatPasswordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func clickCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func clickCreateButton(_ sender: Any) {
        
        guard let username = usernameTextField.text, let name = nameTextField.text,
              let password = passwordTextField.text, let repeatedPassword = repeatPasswordTextField.text
            else
            {
            let alert = AlertHandler.getWarningEmptyFields()
            self.present(alert, animated: true, completion: nil)
                return
            }
        
        if password != repeatedPassword {
            let alert = AlertHandler.getErrorPasswordsNotEquals()
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let newUser = uc?.createProfessional(username: username,name: name,password: password)
        
        if newUser != nil {
            self.dismiss(animated: true)
        } else {
            let alert = AlertHandler.getErrorCannotCreateUser()
            self.present(alert, animated: true, completion: nil)
        }
    }

}
