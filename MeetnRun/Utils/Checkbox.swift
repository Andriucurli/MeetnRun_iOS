//
//  Checkbox.swift
//  MeetnRun
//
//  Created by ALugo on 22/8/22.
//

import UIKit

class Checkbox: UIButton {

    // Images
        let checkedImage = UIImage(named: "baseline_check_box_black_18pt")! as UIImage
        let uncheckedImage = UIImage(named: "baseline_check_box_outline_blank_black_18pt")! as UIImage
        
        // Bool property
        var isChecked: Bool = false {
            didSet {
                if isChecked == true {
                    self.setImage(checkedImage, for: UIControl.State.normal)
                } else {
                    self.setImage(uncheckedImage, for: UIControl.State.normal)
                }
            }
        }
            
        override func awakeFromNib() {
            self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
            self.isChecked = false
        }
            
        @objc func buttonClicked(sender: UIButton) {
            if sender == self {
                isChecked = !isChecked
            }
        }

}
