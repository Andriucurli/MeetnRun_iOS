//
//  AppointmentViewController.swift
//  MeetnRun
//
//  Created by ALugo on 30/8/22.
//

import UIKit
import MessageUI
import EventKit
import EventKitUI

class AppointmentViewController: BaseViewController, MFMailComposeViewControllerDelegate, EKEventEditViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var appointment : Appointment!
    var anything : User!
    let eventStore = EKEventStore()
    var time = Date()
    let ac = AppointmentController()
    let nc = NotificationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ac == nil || nc == nil {
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        anything = user.isProfessional() ? appointment.user : appointment.professional
        nameLabel.text = anything.name
        if anything.photo != nil {
            photoView.image = UIImage(data: anything.photo!)
        }
        timeLabel.text = String(format: "%@, %02d:00", Utils.getDayName(Int(appointment.day))!, appointment.hour)
    }
    
    
    @IBAction func clickCallButton(_ sender: Any) {
        
        guard let phone = anything.phone else {
            let alert = AlertHandler.getWarningNoPhoneAvailable()
            self.present(alert, animated: true)
            return
        }
        
        let numberUrl = URL(string: "tel://\(phone)")!
        if UIApplication.shared.canOpenURL(numberUrl) {
            UIApplication.shared.open(numberUrl)
        } else {
            let alert = AlertHandler.getWarningNoPhoneAvailable()
            self.present(alert, animated: true)
            return
        }
    }
    
    @IBAction func clickEmailButton(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() || anything.email == nil {
            let alert = AlertHandler.getWarningNoPhoneAvailable()
            self.present(alert, animated: true)
            return
        }
        
        let mailView = MFMailComposeViewController()
        mailView.setToRecipients([anything.email!])
        mailView.mailComposeDelegate = self
        self.present(mailView, animated: true)
    }
    
    @IBAction func clickCancelButton(_ sender: Any) {
       
        let confirmAlert = UIAlertController(title: "Cancel Appointment", message: "Do you really want to cancel this appointment?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action : UIAlertAction!) in
            confirmAlert.dismiss(animated: true)
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action : UIAlertAction) in
            if self.ac!.cancelAppointment(appointment: self.appointment){
                _ = self.nc!.createNotification(sender: self.user, receiver: self.anything, type: .CANCELLED, appointment: self.appointment)
                self.navigationController?.popViewController(animated: true)
            }
        })
        
        confirmAlert.addAction(cancelAction)
        confirmAlert.addAction(deleteAction)
        
        self.present(confirmAlert, animated: true)
        
    }
    
    @IBAction func clickModifyButton(_ sender: Any) {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        pickerView.reloadAllComponents()
        let editRadiusAlert = UIAlertController(title: "Choose new schedule", message: "Choose another time to reschedule your appointment.", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (alert : UIAlertAction) in
            if self.day == nil || self.hour == nil {
                editRadiusAlert.dismiss(animated: true)
                let alert = AlertHandler.getWarningEmptyFields()
                self.present(alert, animated: true)
            } else {
                if self.user.isProfessional(){
                    if self.ac!.modifyAppointment(appointment: self.appointment, day: self.day, hour: self.hour) {
                        self.nc!.createNotification(sender: self.user, receiver: self.anything, type: .MODIFIED, appointment: self.appointment)
                    }
                } else {
                    let newAppointment = self.ac?.requestAppointment(professional: self.appointment.professional, pacient: self.user, day: self.day, hour: self.hour)
                    if newAppointment == nil {
                        return
                    }
                    if self.ac!.requestModification(appointment: self.appointment) {
                        self.nc?.createNotification(sender: self.user, receiver: self.anything, type: .NEED_MODIFICATION, appointment: newAppointment)
                    }
                }
            }
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert : UIAlertAction) in
            editRadiusAlert.dismiss(animated: true)
        }))
        self.present(editRadiusAlert, animated: true)
        
    }
    
    
    
    @IBAction func clickCalendarButton(_ sender: Any) {
        
        let recurrenceDay = EKRecurrenceDayOfWeek(Utils.getEKDay(Int(appointment.day))!)
        let recurrenceRule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: [recurrenceDay], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: .none)
        
        guard let firstDate = Utils.nextDayOfWeek(dow: Int(appointment.day), hour: Int(appointment.hour)) else {
            //TODO: crear alerta de calendario y lanzar
            return
        }
        
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.title = String(format: "Appointment with %@", self.anything.name!)
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
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true)
    }
    
    
    var hours : [String] = []
    var day : Int? = nil
    var hour : Int? = nil
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return Utils.Days.count + 1
        } else {
            hours = []
            var count = 1
            if day != nil {
                for hour : Int in 0...23 {
                    let bytei = hour/8
                    let segmentByte = appointment.professional!.schedule![day! * 3 + bytei]
                    let biti = hour%8
                    if Utils.isBitSet(b: segmentByte, bit: 7-biti){
                        hours.append(String(format: "%02d:00", hour))
                        count = count + 1
                    }
                }
            }
            return count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return ""
        }
        if component == 0 {
            return Utils.Days[row-1]
        } else {
            return hours[row-1]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if row == 0 {
                pickerView.selectRow(0, inComponent: 1, animated: true)
            } else {
                day = row - 1
                pickerView.reloadComponent(1)
            }
        } else {
            if row == 0 {
                hour = nil
            } else {
                let hourString = hours[row]
                hour = Int(hourString.split(separator: ":")[0])
            }
        }
    }
    
    
}
