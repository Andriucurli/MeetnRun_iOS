//
//  SignProfessionalController.swift
//  MeetnRun
//
//  Created by ALugo on 29/7/22.
//

import UIKit

class SignProfessionalController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        let uc = UserController()
        
        if uc.createProfessional(username, name, password){
            self.dismiss(animated: true)
        } else {
            let alert = AlertHandler.getErrorCannotCreateUser()
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
