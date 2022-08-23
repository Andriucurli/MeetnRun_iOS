//
//  UserController.swift
//  MeetnRun
//
//  Created by ALugo on 2/8/22.
//

import UIKit
import CoreData

class UserController {
    
    
    public func editUserPhoto(user : User, photoData : Data?){
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
          
          // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        user.photo = photoData
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
    public func editUser(user : User, _ name : String?, _ phone : String?, _ email : String?){
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
          
          // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        user.name = name
        user.phone = phone
        user.email = email
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
    public func createProfessional(_ username : String, _ name : String, _ password : String) -> Bool{
        return createUser(username, name, password, email: nil, professional: nil)
    }
    
    public func createPacient(_ username : String, _ email : String, professional : User) -> Bool{
        return createUser(username, username, username, email: email, professional: professional)
    }
    
    private func createUser (_ username : String, _ name : String, _ password : String, email : String?, professional : User?) -> Bool {
        
        let existingUser = getUser(username)
        
        if existingUser != nil {
            return false
        }
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
          
          // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
          
          
        let user = User(context: managedContext)
        user.username = username
        user.name = name
        user.password = password
        user.email = email
        user.professional = professional
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
              return false
          }
        
        return true
    }
    
    
    func getUser(_ username : String) -> User?{
        
        var users : [User] = []
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return nil
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<User>(entityName: "User")
        
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
          
          //3
          do {
            users = try managedContext.fetch(fetchRequest)
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
        
        if users.count != 1 {
            return nil
        } else {
            return users.first
        }
    }
    
    func getPacients(professional : User) -> [User]? {
        var users : [User] = []
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return nil
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<User>(entityName: "User")
        
        fetchRequest.predicate = NSPredicate(format: "professional = %@", professional)
          
          //3
          do {
            users = try managedContext.fetch(fetchRequest)
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
        
        return users
    }

}
