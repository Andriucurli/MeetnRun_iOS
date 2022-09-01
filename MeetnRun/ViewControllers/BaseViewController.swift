//
//  BaseViewController.swift
//  MeetnRun
//
//  Created by ALugo on 22/8/22.
//

import UIKit

class BaseViewController: UIViewController {

    var user : User!
    let uc = UserController()

    override func viewWillAppear(_ animated: Bool) {
        
        if uc == nil {
            print("FALLO")
        }
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        guard let auxUser = appDelegate.getCurrentUser(uc: uc!) else {
            return
        }
        
        user = auxUser
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
