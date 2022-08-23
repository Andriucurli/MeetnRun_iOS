//
//  UserController.swift
//  MeetnRun
//
//  Created by ALugo on 29/7/22.
//

import UIKit


protocol PHourSetter {
    func setHour(hour : Int, day : Int, value : Bool)
}

class UIScheduleCell : UITableViewCell {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var mondayCheck: UIButton!
    @IBOutlet weak var tuesdayCheck: UIButton!
    @IBOutlet weak var wednesdayCheck: UIButton!
    @IBOutlet weak var thursdayCheck: UIButton!
    @IBOutlet weak var fridayCheck: UIButton!
    @IBOutlet weak var saturdayCheck: UIButton!
    @IBOutlet weak var sundayCheck: UIButton!
    
    var hour : Int = 0
    
    var hourSetter : PHourSetter!
    
    @IBAction func changeHourValue(_ sender : Any){
        let actionButton = sender as! Checkbox
        hourSetter.setHour(hour: self.hour, day: actionButton.tag, value: actionButton.isChecked)
    }
    
}

class UserViewController: BaseViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, PHourSetter {
    func setHour(hour: Int, day: Int, value : Bool) {
        print(hour)
        print(day)
        print(value)
    }
    

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UIScheduleCell
        cell.hourLabel.text = String(format: "%02d:00", indexPath.row)
        cell.hour = indexPath.row
        cell.hourSetter = self
        return cell
    }
    
    
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scheduleTableView: UITableView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.text = user.username
        nameTextField.text = user.name
        emailTextField.text = user.email
        phoneTextField.text = user.phone
        if user.photo != nil {
            photoView.image = UIImage(data: user.photo!)
        }
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        if !user.isProfessional(){
            self.navigationItem.setRightBarButton(nil, animated: false)
        }
        
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
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
        uc.editUser(user: user, nameTextField.text, phoneTextField.text, emailTextField.text)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoView.contentMode = .scaleAspectFit
            photoView.image = pickedImage
            user.photo = pickedImage.pngData()
            uc.editUserPhoto(user: user, photoData: pickedImage.pngData())
            
            }

            dismiss(animated: true, completion: nil)
    }
    
}

