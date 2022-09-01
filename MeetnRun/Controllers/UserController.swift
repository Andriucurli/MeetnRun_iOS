//
//  UserController.swift
//  MeetnRun
//
//  Created by ALugo on 2/8/22.
//

import UIKit
import CoreData

class UserController : BaseController {
    
    public static let initialScheduleByDay = Data([0x00,0xFF,0xF8,
                0x00, 0xFF, 0xF8,
                0x00, 0xFF, 0xF8,
                0x00, 0xFF, 0xF8,
                0x00, 0xFF, 0xF8,
                0x00, 0xFF, 0xF8,
                0x00, 0x00, 0x00]);
    
    public func setSchedule(user : User?,_ schedule : Data?) -> Bool {
        
        if user == nil ||
            schedule == nil {
            return false
        }
        
        user!.schedule = schedule
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
              return false
          }
        return true
    }
    
    public func editUserPhoto(user : User?, photoData : Data?) -> Bool{
        
        if user == nil {
            return false
        }
        
        user!.photo = photoData
        
        do {
            try managedContext.save()
        } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
              return false
          }
        
        return true
    }
    
    public func editUser(user : User?, _ name : String?, _ phone : String?, _ email : String?) -> Bool{
        
        if user == nil {
            return false
        }
        
        user!.name = name
        user!.phone = phone
        user!.email = email
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
              return false
          }
        return true
    }
    
    public func createProfessional(username : String, name : String?, password : String?) -> User?{
        return createUser(username, name, password, email: nil, professional: nil)
    }
    
    public func createPacient(_ username : String?, _ email : String?, professional : User?) -> User?{
        return createUser(username, username, username, email: email, professional: professional)
    }
    
    private func createUser (_ username : String?, _ name : String?, _ password : String?, email : String?, professional : User?) -> User? {
        
        if username == nil ||
            name == nil ||
            password == nil {
            return nil
        }
        
        let existingUser = getUser(username)
        
        if existingUser != nil {
            return nil
        }
          
        let user = User(context: managedContext)
        user.username = username
        user.name = name
        user.password = password
        user.email = email
        user.professional = professional
        
        if professional == nil {
            user.schedule = UserController.initialScheduleByDay
        }
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
              return nil
          }
        
        return user
    }
    
    
    func getUser(_ username : String?) -> User?{
        
        if username == nil {
            return nil
        }
        
        var users : [User] = []
        
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        fetchRequest.predicate = NSPredicate(format: "username == %@", username!)
          
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
    
    func getPacients(professional : User?) -> [User]? {
        var users : [User] = []
        
        if professional == nil {
            return users
        }
        
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        fetchRequest.predicate = NSPredicate(format: "professional = %@", professional!)
          
          do {
            users = try managedContext.fetch(fetchRequest)
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
        
            return users
    }

}
