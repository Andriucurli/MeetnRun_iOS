//
//  BaseController.swift
//  MeetnRun
//
//  Created by ALugo on 26/8/22.
//

import Foundation
import CoreData
import UIKit


class BaseController  {
    
    let managedContext : NSManagedObjectContext
    
    init?() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        managedContext = appDelegate.persistentContainer.viewContext
    }
}
