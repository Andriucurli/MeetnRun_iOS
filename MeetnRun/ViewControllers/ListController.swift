//
//  ListController.swift
//  MeetnRun
//
//  Created by ALugo on 29/7/22.
//

import UIKit

class AppointmentTableViewCell : UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
}

class ListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    let ac = AppointmentController()
    var appointments : [Appointment] = []
    
    @IBOutlet weak var appointmentTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appointments = ac?.getActiveAppointments(user: self.user) ?? []
        appointmentTableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Settings" {
            
        } else if segue.identifier == "Appointment" {
            
            let index = appointmentTableView.indexPathForSelectedRow!
            let appointment = appointments[index.row]
            
            let appointmentVC = segue.destination as! AppointmentViewController
            appointmentVC.appointment = appointment
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appointments.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                emptyLabel.text = "No Active Appointments"
            emptyLabel.textAlignment = NSTextAlignment.center
                appointmentTableView.backgroundView = emptyLabel
            appointmentTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            }
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointment_cell", for: indexPath) as! AppointmentTableViewCell
        let appointment = appointments[indexPath.row]
        let anything = user.isProfessional() ? appointment.user! : appointment.professional!
        cell.nameLabel.text = anything.name
        cell.dayLabel.text = Utils.getDayName(Int(appointment.day))
        cell.hourLabel.text = String(format: "%02d:00", appointment.hour)
        
        return cell
    }
}
