//
//  NotificationsViewController.swift
//  MeetnRun
//
//  Created by ALugo on 4/8/22.
//

import UIKit


protocol UINotificationTableCellActionHandler {
    func clickGreenButton(notification : Notification?)
    func clickRedButton(notification : Notification?)
}

class UINotificationTableCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    var notification : Notification? = nil
    var handler : UINotificationTableCellActionHandler? = nil
    
    func initCell(notification : Notification?, notificationHandler : UINotificationTableCellActionHandler?){
        if notification == nil ||
        notificationHandler == nil {
            return
        }
        self.handler = notificationHandler
        self.notification = notification
        titleLabel.text = notification?.sender?.name
        subtitleLabel.text = notification?.message
        
        if notification!.type != Notification.NType.NEED_CONFIRMATION.rawValue && notification!.type != Notification.NType.NEED_MODIFICATION.rawValue {
            acceptButton.isHidden = true
            rejectButton.isHidden = true
        }
    }
    
    @IBAction func clickGreenAction(_ sender: Any) {
        handler?.clickGreenButton(notification: self.notification)
    }
    
    @IBAction func clickRedAction(_ sender: Any) {
        handler?.clickRedButton(notification: self.notification)
    }
    
    
}

class NotificationsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UINotificationTableCellActionHandler {
    
    let nc = NotificationController()
    var notifications : [Notification] = []
    @IBOutlet weak var notificationsTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notifications = nc?.getPendingNotifications(user: self.user) ?? []
        
        for notification in notifications {
            if notification.type != Notification.NType.NEED_MODIFICATION.rawValue &&
                notification.type != Notification.NType.NEED_CONFIRMATION.rawValue {
                nc?.markNotificationAsSeen(notification: notification)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notifications.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = NSLocalizedString("TEXT_BACKGROUND_NONOTIFICATIONS", comment: "text for the background when there is no notifications")
            emptyLabel.textAlignment = NSTextAlignment.center
                notificationsTableView.backgroundView = emptyLabel
            notificationsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        } else {
            notificationsTableView.backgroundView = nil
        }
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notification_cell", for: indexPath) as! UINotificationTableCell
        let notification = notifications[indexPath.row]
        cell.initCell(notification: notification, notificationHandler: self)
        
        return cell
    }
    
    func clickGreenButton(notification: Notification?) {
        let ac = AppointmentController()
        if notification == nil || ac == nil{
            return
        }
        
        let ntype = Notification.NType(rawValue: notification!.type)
        
        switch ntype {
        case .NEED_CONFIRMATION:
            if ac!.confirmAppointment(appointment: notification?.appointment) {
                nc!.createNotification(sender: notification?.appointment?.professional, receiver: notification?.appointment?.user, type: .CONFIRMED, appointment: notification?.appointment)
            }
            break
        case .NEED_MODIFICATION:
            if ac!.acceptModification(appointment: notification?.appointment) {
                nc!.createNotification(sender: notification?.appointment?.professional, receiver: notification?.appointment?.user, type: .MODIFIED, appointment: notification?.appointment)
            }
            break
        default:
            return
        }
        
        if nc!.markNotificationAsSeen(notification: notification) {
            let index = notifications.firstIndex(of: notification!)
            notifications.remove(at: index!)
            notificationsTableView.reloadData()
        }
    }
    
    func clickRedButton(notification: Notification?) {
        let ac = AppointmentController()
        if notification == nil ||
            ac == nil {
            return
        }
        
        let ntype = Notification.NType(rawValue: notification!.type)
        
        switch ntype {
        case .NEED_CONFIRMATION:
            
            if ac!.cancelAppointment(appointment: notification?.appointment) {
                nc!.createNotification(sender: notification?.appointment?.professional, receiver: notification?.appointment?.user, type: .CANCELLED, appointment: notification?.appointment)
            }
            break
        case .NEED_MODIFICATION:
            if ac!.rejectModification(appointment: notification?.appointment) {
                nc!.createNotification(sender: notification?.appointment?.professional, receiver: notification?.appointment?.user, type: .CANCELLED, appointment: notification?.appointment)
            }
            break
        default:
            return
        }
        if nc!.markNotificationAsSeen(notification: notification) {
            let index = notifications.firstIndex(of: notification!)
            notifications.remove(at: index!)
            notificationsTableView.reloadData()
        }
    }

}
