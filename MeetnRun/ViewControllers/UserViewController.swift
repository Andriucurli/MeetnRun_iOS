//
//  UserController.swift
//  MeetnRun
//
//  Created by ALugo on 29/7/22.
//

import UIKit


protocol ScheduleHourSetter {
    func setHour(hour : Int, day : Int, value : Bool)
    func checkHour(day : Int, hour : Int) -> Bool
}

class UIScheduleCell : UITableViewCell {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var mondayCheck: Checkbox!
    @IBOutlet weak var tuesdayCheck: Checkbox!
    @IBOutlet weak var wednesdayCheck: Checkbox!
    @IBOutlet weak var thursdayCheck: Checkbox!
    @IBOutlet weak var fridayCheck: Checkbox!
    @IBOutlet weak var saturdayCheck: Checkbox!
    @IBOutlet weak var sundayCheck: Checkbox!
    
    var hour : Int = 0
    
    var hourSetter : ScheduleHourSetter!
    
    @IBAction func changeHourValue(_ sender : Any){
        let actionButton = sender as! Checkbox
        
        if actionButton.isChecked && !hourSetter.checkHour(day: actionButton.tag, hour: self.hour) {
            actionButton.isChecked = !actionButton.isChecked
            return
        }
        
        hourSetter.setHour(hour: self.hour, day: actionButton.tag, value: !actionButton.isChecked)
    }
    
}

class UserViewController: BaseViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, ScheduleHourSetter {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scheduleTableView: UITableView!
    
    @IBOutlet weak var availableScheduleTitle: UILabel!
    @IBOutlet weak var scheduleHeader: UIView!
    @IBOutlet weak var scheduleTable: UIScrollView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    let ac = AppointmentController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initForm()
    }
    
    func initForm(){
        usernameTextField.text = user.username
        nameTextField.text = user.name
        emailTextField.text = user.email
        phoneTextField.text = user.phone
        if user.photo != nil {
            photoView.image = UIImage(data: user.photo!)
        }
        
        if !user.isProfessional(){
            self.navigationItem.setRightBarButton(nil, animated: false)
            availableScheduleTitle.isHidden = true
            scheduleHeader.isHidden = true
            scheduleTable.isHidden = true
            mainScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: mainScrollView.frame.height)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func clickAddPhoto(_ sender: Any) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let menu = UIAlertController(title: "Photo Source", message: "Select an option", preferredStyle: .actionSheet)
            menu.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(alert : UIAlertAction) -> Void in
                imageController.sourceType = .camera
            }))
            menu.addAction(UIAlertAction(title: "Album Roll", style: .default, handler: {(alert : UIAlertAction) -> Void in
                imageController.sourceType = .savedPhotosAlbum
            }))
        } else {
            imageController.sourceType = .savedPhotosAlbum
        }
        present(imageController, animated: true, completion: nil)
    }
    
    @IBAction func changeUserData(_ sender: Any){
        uc?.editUser(user: user, nameTextField.text, phoneTextField.text, emailTextField.text)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoView.contentMode = .scaleAspectFit
            photoView.image = pickedImage
            user.photo = pickedImage.pngData()
            uc?.editUserPhoto(user: user, photoData: pickedImage.pngData())
            
            }

            dismiss(animated: true, completion: nil)
    }
    
    func checkHour(day: Int, hour: Int) -> Bool{
        return ac?.checkAppointment(user: self.user, day: day, hour: hour) ?? false
    }
    
    func setHour(hour: Int, day: Int, value : Bool) {
        
        if user.schedule != nil {
            let bytei = hour/8;
            let segmentByte = user.schedule![day * 3 + bytei];
            let biti = hour%8;

            user.schedule![day * 3 + bytei] = Utils.setBit(b: segmentByte, bit: 7-biti, value: value);
            
            uc?.setSchedule(user: user, user.schedule)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hour = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UIScheduleCell
        cell.hourLabel.text = String(format: "%02d:00", hour)
        cell.hour = hour
        
        if user.isProfessional() {
            for day : Int in 0...6 {
                var checkbox : Checkbox?
                switch day {
                case 0:
                    checkbox = cell.mondayCheck
                    break
                case 1:
                    checkbox = cell.tuesdayCheck
                    break
                case 2:
                    checkbox = cell.wednesdayCheck
                    break
                case 3:
                    checkbox = cell.thursdayCheck
                    break
                case 4:
                    checkbox = cell.fridayCheck
                    break
                case 5:
                    checkbox = cell.saturdayCheck
                    break
                case 6:
                    checkbox = cell.sundayCheck
                    break
                default:
                    print("FALLO")
                }
                
                let bytei = hour/8
                let segmentByte = user.schedule![day * 3 + bytei]
                let biti = hour%8
                
                if Utils.isBitSet(b: segmentByte, bit: 7-biti){
                    checkbox?.isChecked = true
                }
            }
        }
        
        cell.hourSetter = self
        return cell
    }
}

