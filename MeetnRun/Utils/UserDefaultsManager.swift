//
//  UserDefaultsManager.swift
//  MeetnRun
//
//  Created by ALugo on 22/8/22.
//

import UIKit

class UserDefaultsManager: NSObject {
    
    static func login(_ username : String){
        UserDefaults.standard.set(username, forKey: "logged_username")
        UserDefaults.standard.synchronize()
    }
    
    static func logout(){
        UserDefaults.standard.removeObject(forKey: "logged_username")
        UserDefaults.standard.synchronize()
    }
    
    static func getUsername() -> String?{
        return UserDefaults.standard.string(forKey: "logged_username")
    }
    
    static func setConfigValues(notificationsEnabled : Bool, createEventsAuto : Bool){
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(createEventsAuto, forKey: "createRecordatoriesAuto")
        UserDefaults.standard.synchronize()
    }
    
    static func getNotificationsEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "notificationsEnabled")
    }
    
    static func getCreateRecordatoriesAuto()-> Bool {
        return UserDefaults.standard.bool(forKey: "createRecordatoriesAuto")
    }
    
    
}
