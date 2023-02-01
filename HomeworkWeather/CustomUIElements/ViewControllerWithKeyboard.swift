//
//  KeyboardDismissable.swift
//  HomeworkL6ImpressMe
//
//  Created by Alex Partulov on 12.01.23.
//

import UIKit


class ViewControllerWithKeyboard: UIViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addKeyboardDismissRecognizer()
    }
    
    func addKeyboardDismissRecognizer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

}
