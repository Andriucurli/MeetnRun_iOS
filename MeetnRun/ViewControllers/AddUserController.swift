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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func clickCreateUser(_ sender: Any) {
        if !usernameTextField.hasText ||
            !emailTextField.hasText {
            let alert = AlertHandler.getWarningEmptyFields()
            self.present(alert, animated: true, completion: nil)
        } else {
            if (uc.createPacient(usernameTextField.text!, emailTextField.text!, professional: self.user)){
                self.dismiss(animated: true)
            } else {
                let alert = AlertHandler.getErrorCannotCreateUser()
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
