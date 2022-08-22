//
//  BaseViewController.swift
//  MeetnRun
//
//  Created by ALugo on 22/8/22.
//

import UIKit

class BaseViewController: UIViewController {

    let uc = UserController()
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let username = UserDefaultsManager.getUsername() else {
            return
        }
        user = uc.getUser(username)!
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
