//
//  SettingsController.swift
//  MeetnRun
//
//  Created by ALugo on 23/8/22.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var recordatoriesSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsSwitch.isOn = UserDefaultsManager.getNotificationsEnabled()
        recordatoriesSwitch.isOn = UserDefaultsManager.getCreateRecordatoriesAuto()
    }
    
    @IBAction func saveSettings(_ sender : Any){
        UserDefaultsManager.setConfigValues(notificationsEnabled: notificationsSwitch.isOn, createEventsAuto: recordatoriesSwitch.isOn)
    }
    @IBAction func clickLogout(_ sender: Any) {
        UserDefaultsManager.logout()
        self.dismiss(animated: false)
    }
    
}
