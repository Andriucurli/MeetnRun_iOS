//
//  AddAppointmentControllerViewController.swift
//  MeetnRun
//
//  Created by ALugo on 29/7/22.
//

import UIKit
import EventKit
import EventKitUI

protocol AppointmentHourSetter {
    func setHour(hour : Int?)
}

class AddAppointmentController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, AppointmentHourSetter, EKEventEditViewDelegate {
   
    
    
    @IBOutlet weak var anythingPicker: UIPickerView!
    @IBOutlet weak var anythingLabel: UILabel!
    @IBOutlet weak var dayPickerView: UIPickerView!
    @IBOutlet weak var hourPickerView: UIPickerView!
    @IBOutlet weak var addAppointmentButton: UIButton!
    
    
    var pacients : [User]? = nil
    
    var selectedAnything : User? = nil
    var selectedDay : Int? = nil
    var selectedHour : Int? = nil
    
    var hourPickerVC : HourPickerViewController!
    
    let eventStore = EKEventStore()
    var time = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anythingPicker.isUserInteractionEnabled = false
        dayPickerView.isUserInteractionEnabled = false
        hourPickerView.isUserInteractionEnabled = false
        
        dayPickerView.delegate = self
        dayPickerView.dataSource = self
        anythingPicker.delegate = self
        anythingPicker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (user.isProfessional()){
            anythingLabel.text = "Pacients"
            pacients = uc?.getPacients(professional: user)
            anythingPicker.isUserInteractionEnabled = true
            
        } else {
            anythingLabel.isHidden = true
            anythingPicker.isHidden = true
            dayPickerView.isUserInteractionEnabled = true
        }
        
        hourPickerVC = HourPickerViewController(schedule: user.schedule ?? user.professional!.schedule!, setter: self)
        hourPickerView.delegate = hourPickerVC
        hourPickerView.dataSource = hourPickerVC
        
        anythingPicker.selectRow(0, inComponent: 0, animated: false)
        dayPickerView.selectRow(0, inComponent: 0, animated: false)
        hourPickerVC.day = nil
        hourPickerView.reloadAllComponents()
    }
    
    func setHour(hour: Int?) {
        self.selectedHour = hour
    }
    
    @IBAction func clickAddAppointmentButton(_ sender: Any) {
        
        guard let ac = AppointmentController() else {
            print("FALLO")
            return
        }
        
        guard let nc = NotificationController() else {
            print("FALLO")
            return
        }
        
        
        if selectedDay == nil || selectedHour == nil || (user.isProfessional() && selectedAnything == nil){
            let alert = AlertHandler.getWarningEmptyFields()
            self.present(alert, animated: true)
        } else {
            var appointment : Appointment? = nil
            if !user.isProfessional() {
                selectedAnything = user.professional
                appointment = ac.requestAppointment(professional: selectedAnything, pacient: user, day: selectedDay, hour: selectedHour)
            } else {
                appointment = ac.createAppointment(professional: user, pacient: selectedAnything, day: selectedDay, hour: selectedHour)
            }
            
            if appointment == nil {
                let alert = AlertHandler.getErrorCannotCreateAppointment()
                self.present(alert, animated: true)
            } else {
                let type = user.isProfessional() ? Notification.NType.CREATED : Notification.NType.NEED_CONFIRMATION
                if let _ = nc.createNotification(sender: user, receiver: selectedAnything, type: type, appointment: appointment) {
                    
                    if UserDefaultsManager.getCreateRecordatoriesAuto() {
                        let recurrenceDay = EKRecurrenceDayOfWeek(Utils.getEKDay(Int(appointment!.day))!)
                        let recurrenceRule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: [recurrenceDay], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: .none)
                        
                        guard let firstDate = Utils.nextDayOfWeek(dow: Int(appointment!.day), hour: Int(appointment!.hour)) else {
                            //TODO: crear alerta de calendario y lanzar
                            return
                        }
                        
                        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
                            DispatchQueue.main.async {
                                if (granted) && (error == nil) {
                                    let event = EKEvent(eventStore: self.eventStore)
                                    event.title = String(format: "Appointment with %@", appointment!.user!.name!)
                                    event.startDate = firstDate
                                    event.recurrenceRules = [recurrenceRule]
                                    event.endDate = firstDate.addingTimeInterval(60*60)
                                    let eventController = EKEventEditViewController()
                                    eventController.event = event
                                    eventController.eventStore = self.eventStore
                                    eventController.editViewDelegate = self
                                    self.present(eventController, animated: true, completion: nil)
                                }
                            }
                        })
                    } else {
                        let alert : UIAlertController!
                        if user.isProfessional() {
                            alert = AlertHandler.getInfoAppointmentCreated()
                        } else {
                            alert = AlertHandler.getInfoAppointmentRequested()
                        }
                        self.present(alert, animated: true)
                    }
                }
                
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return Utils.Days.count + 1
        } else if pickerView.tag == 0 {
            return pacients == nil ? 0 : pacients!.count + 1
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return row == 0 ? "" : Utils.Days[row-1]
        } else if pickerView.tag == 0 {
            return row == 0 ? "" : pacients?[row-1].name
        }
        
        return nil
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 0:
            if row == 0 {
                dayPickerView.isUserInteractionEnabled = false
                dayPickerView.selectRow(0, inComponent: 0, animated: true)
                hourPickerView.selectRow(0, inComponent: 0, animated: true)
            } else {
                selectedAnything = pacients![row-1]
                dayPickerView.isUserInteractionEnabled = true
            }
            break
        case 1:
            if row == 0 {
                hourPickerView.isUserInteractionEnabled = false
                hourPickerView.selectRow(0, inComponent: 0, animated: true)
                hourPickerVC.day = nil
            } else {
                hourPickerView.selectRow(0, inComponent: 0, animated: true)
                hourPickerView.isUserInteractionEnabled = true
                selectedDay = row-1
                hourPickerVC.day = selectedDay
            }
            
            hourPickerView.reloadComponent(0)
            break
        default:
           print("FALLO")
            break
        }
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true)
    }
}

class HourPickerViewController : NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let schedule : Data
    var day : Int!
    var hours : [String] = []
    let setter : AppointmentHourSetter
    
    init(schedule : Data, setter : AppointmentHourSetter){
        self.schedule = schedule
        self.setter = setter
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        hours = []
        var count = 1
        if day != nil {
            for hour : Int in 0...23 {
                let bytei = hour/8
                let segmentByte = schedule[day * 3 + bytei]
                let biti = hour%8
                if Utils.isBitSet(b: segmentByte, bit: 7-biti){
                    hours.append(String(format: "%02d:00", hour))
                    count = count + 1
                }
            }
        }
    
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return ""
        }
        return hours[row-1]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0
        {
            return
        }
        let hour = hours[row-1]
        let hourInt = Int(hour.split(separator: ":")[0])
        setter.setHour(hour: hourInt)
    }
}
