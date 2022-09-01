//
//  AddUserController.swift
//  MeetnRun
//
//  Created by ALugo on 29/7/22.
//

import UIKit

class AddUserController: BaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickCreateUser(_ sender: Any) {
        if !usernameTextField.hasText ||
            !emailTextField.hasText {
            let alert = AlertHandler.getWarningEmptyFields()
            self.present(alert, animated: true, completion: nil)
        } else {
            let newPacient = uc?.createPacient(usernameTextField.text, emailTextField.text, professional: self.user)
            if newPacient != nil{
                self.dismiss(animated: true)
            } else {
                let alert = AlertHandler.getErrorCannotCreateUser()
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
