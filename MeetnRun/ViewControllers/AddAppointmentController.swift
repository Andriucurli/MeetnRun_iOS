//
//  AddAppointmentControllerViewController.swift
//  MeetnRun
//
//  Created by ALugo on 29/7/22.
//

import UIKit

class AddAppointmentController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    @IBOutlet weak var anythingPicker: UIPickerView!
    @IBOutlet weak var anythingLabel: UILabel!
    @IBOutlet weak var dayPickerView: UIPickerView!
    @IBOutlet weak var hourPickerView: UIPickerView!
    @IBOutlet weak var addAppointmentButton: UIButton!
    
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (user.isProfessional()){
            anythingLabel.text = "Pacients"
        } else {
            anythingLabel.isHidden = true
            anythingPicker.isHidden = true
        }
        
        // Do any additional setup after loading the view.
        
        dayPickerView.delegate = self
        
        dayPickerView.dataSource = self
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func clickAddAppointmentButton(_ sender: Any) {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return days.count
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return days[row]
        }
        
        return nil
    }
    
    
}
