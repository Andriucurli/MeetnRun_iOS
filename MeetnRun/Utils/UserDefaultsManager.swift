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
}
