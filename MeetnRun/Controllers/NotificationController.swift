//
//  NotificationController.swift
//  MeetnRun
//
//  Created by ALugo on 24/8/22.
//

import UIKit
import CoreData

class NotificationController : BaseController {
        
    func createNotification(sender : User?, receiver : User?, type : Notification.NType?, appointment : Appointment?) -> Notification? {
          
        if sender == nil ||
            receiver == nil ||
            type == nil ||
            appointment == nil {
            return nil
        }
          
        let notification = Notification(context: managedContext)
        
        notification.sender = sender
        notification.receiver = receiver
        notification.message = Notification.getMessageByType(type: type!, sender: sender)
        notification.type = Int16(type!.rawValue)
        notification.appointment = appointment
        notification.seen = false
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
              return nil
          }
        
        return notification
    }
    
    func getPendingNotifications(user : User?) -> [Notification]{
        var notifications : [Notification] = []
        
        if user == nil {
            return notifications
        }
        
        let fetchRequest =
          NSFetchRequest<Notification>(entityName: "Notification")
        fetchRequest.predicate = NSPredicate(format: "receiver = %@ && seen = false", user!)
        
        do {
          notifications = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
        
        return notifications
    }
    
    func markNotificationAsSeen(notification : Notification?) -> Bool {
        if notification == nil {
            return false
        }
        
        notification!.seen = true
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
              return false
          }
        return true
    }

}
