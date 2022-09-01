//
//  AppointmentController.swift
//  MeetnRun
//
//  Created by ALugo on 24/8/22.
//

import UIKit
import CoreData

class AppointmentController: BaseController {
    
    private func createAppointment(_ professional : User?, _ pacient : User?, _ day : Int?, _ hour : Int?, _ status : Appointment.Status?) -> Appointment? {
          
        if professional == nil ||
            pacient == nil ||
            day == nil ||
            hour == nil ||
            status == nil {
            return nil
        }
        
        let appointment = Appointment(context: managedContext)
        
        appointment.professional = professional
        appointment.user = pacient
        appointment.day = Int16(day!)
        appointment.hour = Int16(hour!)
        appointment.status = Int16(status!.rawValue)
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
              return nil
          }
        
        return appointment
    }
    
    public func requestAppointment(professional : User?, pacient : User?, day : Int?, hour : Int?) -> Appointment?{
        return createAppointment(professional, pacient, day, hour, .REQUESTED)
       }

    public func createAppointment(professional : User?, pacient : User?, day : Int?, hour : Int?) -> Appointment?{
        return createAppointment(professional, pacient, day, hour, .CONFIRMED)
    }
    
    public func getActiveAppointments(user : User?) -> [Appointment]{
        
        var appointments : [Appointment] = []
        
        if user == nil {
            return appointments
        }
        
        let fetchRequest =
          NSFetchRequest<Appointment>(entityName: "Appointment")
        
        if user!.isProfessional(){
            fetchRequest.predicate = NSPredicate(format: "professional = %@ && status = %@", user!, NSNumber(value:Appointment.Status.CONFIRMED.rawValue))
        } else {
            fetchRequest.predicate = NSPredicate(format: "user = %@ && status = %@", user!, NSNumber(value:Appointment.Status.CONFIRMED.rawValue))
        }
        
        do {
          appointments = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
        
        return appointments
    }
    
    public func requestModification(appointment : Appointment?) -> Bool {
        return changeAppointmentStatus(appointment, .MODIFICATION_REQUESTED)
    }
    
    public func confirmAppointment(appointment : Appointment?) -> Bool{
        return changeAppointmentStatus(appointment, .CONFIRMED)
    }
    
    public func cancelAppointment(appointment : Appointment?) -> Bool{
        return changeAppointmentStatus(appointment, .CANCELLED)
    }
    
    public func acceptModification(appointment : Appointment?) -> Bool {
        
        if appointment == nil {
            return false
        }
        
        var results : [Appointment] = []
                
        let fetchRequest =
          NSFetchRequest<Appointment>(entityName: "Appointment")
        
        fetchRequest.predicate = NSPredicate(format: "professional = %@ AND user = %@ AND status = %d", appointment!.professional!, appointment!.user!, Appointment.Status.MODIFICATION_REQUESTED.rawValue)
        
        do {
          results = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        
        if results.count > 1 {
            return false
        }
        
        do {
            if !changeAppointmentStatus(appointment, .CONFIRMED){
                return false
            }
            let oldAppointment = results[0]
            oldAppointment.status = Int16(Appointment.Status.CANCELLED.rawValue)
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
              return false
          }
        return true
    }
    
    public func rejectModification(appointment : Appointment?) -> Bool{
        if appointment == nil {
            return false
        }
        
        var results : [Appointment] = []
                
        let fetchRequest =
          NSFetchRequest<Appointment>(entityName: "Appointment")
        
        fetchRequest.predicate = NSPredicate(format: "professional = %@ AND user = %@ AND status = %d", appointment!.professional!, appointment!.user!, Appointment.Status.MODIFICATION_REQUESTED.rawValue)
        
        do {
          results = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        
        if results.count > 1 {
            return false
        }
        
        do {
            if !changeAppointmentStatus(appointment, .CANCELLED){
                return false
            }
            let oldAppointment = results[0]
            oldAppointment.status = Appointment.Status.CONFIRMED.rawValue
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
              return false
          }
        return true
    }
    
    private func changeAppointmentStatus(_ appointment : Appointment?, _ status : Appointment.Status?) -> Bool {

        if appointment == nil ||
            status == nil {
            return false
        }
        
        appointment!.status = Int16(status!.rawValue)
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
              return false
          }
        return true
    }
    
    public func modifyAppointment(appointment : Appointment?, day : Int?, hour : Int?) -> Bool {
        if appointment == nil ||
            day == nil ||
            hour == nil {
            return false
        }
        
        appointment?.day = Int16(day!)
        appointment?.hour = Int16(hour!)
        
        do {
            try managedContext.save()
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
              return false
          }
        return true
    }
    
    public func checkAppointment(user : User?, day: Int?, hour : Int?) -> Bool {
        
        if user == nil ||
            day == nil ||
            hour == nil {
            return false
        }
        
        var results : [Appointment] = []
                
        let fetchRequest =
          NSFetchRequest<Appointment>(entityName: "Appointment")
        
        
        
        if user!.isProfessional(){
            fetchRequest.predicate = NSPredicate(format: "professional = %@ AND day = %d AND hour = %d AND status = %d", user!, day!, hour!, Appointment.Status.CONFIRMED.rawValue)
        } else {
            fetchRequest.predicate = NSPredicate(format: "user = %@ AND day = %d AND hour = %d AND status = %d", user!, day!, hour!, Appointment.Status.CONFIRMED.rawValue)
        }
        
        do {
          results = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
        
        return results.count == 0
    }

}
