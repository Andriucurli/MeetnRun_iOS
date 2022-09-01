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
            formatString = NSLocalizedString("MESSAGE_TYPE_CREATED", comment: "message for created type")
            break
        case .NEED_CONFIRMATION:
            formatString = NSLocalizedString("MESSAGE_TYPE_NEED_CONFIRMATION", comment: "message for need_confirmation type")
            break
        case .CONFIRMED:
            formatString = NSLocalizedString("MESSAGE_TYPE_CONFIRMED", comment: "message for confirmed type")
            break
        case .NEED_MODIFICATION:
            formatString = NSLocalizedString("MESSAGE_TYPE_NEED_MODIFICATION", comment: "message for need_modification type")
            break
        case .MODIFIED:
            formatString = NSLocalizedString("MESSAGE_TYPE_MODIFIED", comment: "message for modified type")
            break
        case .CANCELLED:
            formatString = NSLocalizedString("MESSAGE_TYPE_CANCELLED", comment: "message for cancelled type")
            break
        }
        
        return String(format: formatString, sender?.name ?? "No Name")
    }
}
