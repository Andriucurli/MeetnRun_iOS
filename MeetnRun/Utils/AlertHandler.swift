//
//  AlertHandler.swift
//  MeetnRun
//
//  Created by ALugo on 2/8/22.
//

import UIKit

 class AlertHandler: NSObject {

     static func getWarningEmptyFields() -> UIAlertController {
         let alertView = UIAlertController(title: NSLocalizedString("WARNING", comment: "warning"), message: NSLocalizedString("MESSAGE_WARNING_EMPTYFIELDS", comment: "Message of warning for empty fields"), preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getErrorPasswordsNotEquals() -> UIAlertController {
         let alertView = UIAlertController(title: "Error", message: NSLocalizedString("MESSAGE_ERROR_PASSWORDNOTEQUALS", comment: "message of error for password not equals"), preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getErrorIncorrectUsernamePassword() -> UIAlertController {
         let alertView = UIAlertController(title: "Error", message: NSLocalizedString("MESSAGE_ERROR_INCORRECTUSERNAMEPASSWORD", comment: "message of error in username or password"), preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getErrorCannotCreateUser() -> UIAlertController {
         let alertView = UIAlertController(title: "Error", message: NSLocalizedString("MESSAGE_ERROR_CANNOTCREATEUSER", comment: "error message in user  creation"), preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getErrorCannotCreateAppointment() -> UIAlertController {
         let alertView = UIAlertController(title: "Error", message: NSLocalizedString("MESSAGE_ERROR_CANNOTCREATEAPPOINTMENT", comment: "error message in appointment creation"), preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getInfoAppointmentCreated() -> UIAlertController {
         let alertView = UIAlertController(title: "Info", message: NSLocalizedString("MESSAGE_INFO_APPOINTMENTCREATED", comment: "Info message in appointment creation"), preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getInfoAppointmentRequested() -> UIAlertController {
         let alertView = UIAlertController(title: "Info", message: NSLocalizedString("MESSAGE_INFO_APPOINTMENTREQUESTED", comment: "info message in appointment request"), preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getWarningNoPhoneAvailable() -> UIAlertController {
         let alertView = UIAlertController(title: NSLocalizedString("WARNING", comment: "warning"), message: NSLocalizedString("MESSAGE_WARNING_NOPHONEAVAILABLE", comment: "warning message for no phone available"), preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
     
     static func getWarningNoMailAvailable() -> UIAlertController {
         let alertView = UIAlertController(title: NSLocalizedString("WARNING", comment: "warning"), message: NSLocalizedString("MESSAGE_WARNING_NOMAILAVAILABLE", comment: "warning message for mail generation"), preferredStyle: .alert)
         alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         
         return alertView
     }
}
