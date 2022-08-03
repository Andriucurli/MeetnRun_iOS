//
//  ViewController.swift
//  MeetnRun
//
//  Created by ALugo on 29/7/22.
//

import UIKit

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clickSignUpProfessional(_ sender: Any) {
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let secondVC = storyboard.instantiateViewController(identifier: "SignProfessionalController")
               
               secondVC.modalPresentationStyle = .fullScreen
               secondVC.modalTransitionStyle = .crossDissolve
               
               present(secondVC, animated: true, completion: nil)
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "HomeNavController")
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }
}

