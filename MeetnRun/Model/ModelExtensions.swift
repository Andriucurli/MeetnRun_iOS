//
//  ModelExtensions.swift
//  MeetnRun
//
//  Created by ALugo on 22/8/22.
//

import Foundation


extension User {
    func isProfessional()->Bool{
        return self.professional == nil
    }
}

extension Appointment {
    
    enum Status : Int16 {
        case REQUESTED = 0
        case CONFIRMED = 1
        case CANCELLED = 2
        case MODIFICATION_REQUESTED = 3
    }
    
}

extension Notification {
    enum NType : Int16 {
        case CREATED = 0
        case NEED_CONFIRMATION = 1
        case CONFIRMED = 2
        case NEED_MODIFICATION = 3
        case MODIFIED = 4
        case CANCELLED = 5
    }
    
    
    static func getMessageByType(type : NType, sender : User?) -> String{
        var formatString = ""
        switch type {
        case .CREATED:
            formatString = "An appointment with %@ has been created"
            break
        case .NEED_CONFIRMATION:
            formatString = "An appointment with %@ has been requested"
            break
        case .CONFIRMED:
            formatString = "An appointment with %@ has been confirmed"
            break
        case .NEED_MODIFICATION:
            formatString = "%@ has requested a modification of the appointment"
            break
        case .MODIFIED:
            formatString = "The appointment with %@ has been modified"
            break
        case .CANCELLED:
            formatString = "An appointment with %@ was cancelled"
            break
        }
        
        return String(format: formatString, sender?.name ?? "No Name")
    }
}
