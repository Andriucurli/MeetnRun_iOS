//
//  UserController.swift
//  MeetnRun
//
//  Created by ALugo on 29/7/22.
//

import UIKit

class UserViewController: BaseViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
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

