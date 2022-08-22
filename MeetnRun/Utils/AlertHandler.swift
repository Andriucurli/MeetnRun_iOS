//
//  AlertHandler.swift
//  MeetnRun
//
//  Created by ALugo on 2/8/22.
//

import UIKit

 class AlertHandler: NSObject {

     static func getWarningEmptyFields() -> UIAlertController {
         let alertView = UIAlertController(title: "Warning", message: "Some fields are empty. Please, check the provided info or try it later.", preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getErrorPasswordsNotEquals() -> UIAlertController {
         let alertView = UIAlertController(title: "Error", message: "The passwords are not the same.", preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getErrorIncorrectUsernamePassword() -> UIAlertController {
         let alertView = UIAlertController(title: "Error", message: "Incorrect username or password", preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getErrorCannotCreateUser() -> UIAlertController {
         let alertView = UIAlertController(title: "Error", message: "Cannot create user. Check the fields or try later", preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
}
