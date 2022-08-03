//
//  UserController.swift
//  MeetnRun
//
//  Created by ALugo on 2/8/22.
//

import UIKit
import CoreData

class UserController: BaseController {
    
    func createUser (_ username : String, _ name : String, _ password : String) -> Bool {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
          
          // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
          
          // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "User",
                                       in: managedContext)!
          
        let user = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
          
          // 3
        user.setValue(username, forKeyPath: "username")
        user.setValue(name, forKey: "name")
        user.setValue(password, forKey: "password")
          // 4
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
        
        return true
    }

}
