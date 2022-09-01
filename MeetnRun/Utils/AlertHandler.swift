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
     
     static func getErrorCannotCreateAppointment() -> UIAlertController {
         let alertView = UIAlertController(title: "Error", message: "Cannot create appointment. Check the fields or try later", preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getInfoAppointmentCreated() -> UIAlertController {
         let alertView = UIAlertController(title: "Info", message: "Appointment created!", preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getInfoAppointmentRequested() -> UIAlertController {
         let alertView = UIAlertController(title: "Info", message: "Appointment requested!", preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getWarningNoPhoneAvailable() -> UIAlertController {
         let alertView = UIAlertController(title: "Warning", message: "The call is unavailable because the number is not registered for this user or the call functionality is not available in your device.", preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getWarningNoMailAvailable() -> UIAlertController {
         let alertView = UIAlertController(title: "Warning", message: "The email is unavailable because the email address is not registered for this user.", preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
}
