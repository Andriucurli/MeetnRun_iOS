//
//  HomeTabControllerViewController.swift
//  MeetnRun
//
//  Created by ALugo on 29/7/22.
//

import UIKit

class HomeTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let nc = NotificationController() else {
            print("ERROR INIT NC")
            return
        }
        
        guard let uc = UserController() else {
            print("ERROR INIT UC")
            return
        }
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        guard let user = appDelegate.getCurrentUser(uc: uc) else {
            return
        }
        
        if UserDefaultsManager.getNotificationsEnabled() && nc.getPendingNotifications(user: user).count > 0 {
            
            let content = UNMutableNotificationContent()
            content.title = NSLocalizedString("NOTIFICATION_TITLE", comment: "Title for the notification")
            content.body = NSLocalizedString("NOTIFICATION_BODY", comment: "Body for the notification")
            content.sound = UNNotificationSound.default

            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
        }
    }
}
