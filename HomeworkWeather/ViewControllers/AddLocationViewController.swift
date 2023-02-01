//
//  AddLocationViewController.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 25.01.23.
//

import UIKit

class AddLocationViewController: ViewControllerWithKeyboard {
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var isLocationDefaultSwitch: UISwitch!
    var locationManager:LocationManager?
    var closing:Bool = false
    var editedLocation:LocationRealm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLocationUpdatedObserver()
        self.locationNameTextField.delegate = self
        self.latitudeTextField.delegate = self
        self.longitudeTextField.delegate = self
        if editedLocation == nil{
            locationNameTextField.becomeFirstResponder()
        }
        else {
            self.locationNameTextField.text = self.editedLocation!.name
            self.latitudeTextField.text = self.editedLocation!.latitude
            self.longitudeTextField.text = self.editedLocation!.longitude
            self.isLocationDefaultSwitch.isOn = self.editedLocation!.isDefault
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.closing = true
        super.viewWillDisappear(animated)
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: .locationUpdated, object: nil)
    }
    
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if self.closing {
            return true
        }
        guard let value = textField.text,
              textField.hasText
        else{
            self.showError(error: "This field is requied!", forTextField: textField)
            return false
        }
        
        switch textField{
        case locationNameTextField:
            locationNameTextField.text = locationNameTextField.text?.capitalized
        case latitudeTextField, longitudeTextField:
            guard let _ = Double(value)
            else{
                self.showError(error: "This field must contain number!", forTextField: textField)
                return false
            }
        default:
            return true
        }
        return true
    }
    
    func showError(error:String, forTextField : UITextField){
        let error = Snackbar.init(text: error, view: self.view, caller: forTextField)
        error.font = UIFont.boldSystemFont(ofSize: 16)
        error.padding = 4
        error.show(stayTime: 3, showTime: 1, hideTime: 1)
    }
}

// Get current location
extension AddLocationViewController{
    func addLocationUpdatedObserver(){
        NotificationCenter.default.addObserver(forName: .locationUpdated, object: nil, queue: nil) {
            notification in
            guard let coordinates = notification.object as? Coordinates
            else {
                print("Error")
                return
            }
            self.setCurrentCoordinate(coordinates: coordinates)
        }
    }
    
    func setCurrentCoordinate(coordinates:Coordinates){
        self.latitudeTextField.text = coordinates.latitude
        self.longitudeTextField.text = coordinates.longitude
    }
    
    @IBAction func getCurrentLocation(_ sender: Any) {
        if self.locationManager == nil {
            self.locationManager = LocationManager()
        }
        self.locationManager!.startUpdatingLocation()
    }
}

// save location
extension AddLocationViewController{
    @IBAction func saveLocation(_ sender: Any) {
        let isLocationNameCorrentFillIn = self.textFieldShouldEndEditing(self.locationNameTextField)
        let isLatitudeCorrentFillIn = self.textFieldShouldEndEditing(self.latitudeTextField)
        let isLongitudeCorrentFillIn = self.textFieldShouldEndEditing(self.longitudeTextField)
        
        guard isLocationNameCorrentFillIn && isLatitudeCorrentFillIn && isLongitudeCorrentFillIn
        else {
            return
        }
        
        if self.editedLocation != nil {
            self.editLocation()
            return
        }
        
        let name = self.locationNameTextField.text
        
        let editedLocation = DataManagerRealm.realm.objects(LocationRealm.self).filter("name == \"\(name!)\"").first
        
        if editedLocation == nil {
            self.addToDb()
        } else {
            self.showAlert()
            self.editedLocation = editedLocation
        }
    }
    
    func editLocation(){
        if self.isLocationDefaultSwitch.isOn{
            self.changeDefault()
        }
        
        try! DataManagerRealm.realm.write{
            self.editedLocation?.name = self.locationNameTextField.text!
            self.editedLocation?.latitude = self.latitudeTextField.text!
            self.editedLocation?.longitude = self.longitudeTextField.text!
            self.editedLocation?.isDefault = self.isLocationDefaultSwitch.isOn
        }

        
        self.savedSuccesfully(action: "edited")
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Location with this name already exist!", message: "Do you want to override it?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default){_ in
            self.editLocation()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel){
            _ in
            self.editedLocation = nil
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated:true)
    }
    
    func addToDb(){
        let name = self.locationNameTextField.text
        let latitude = self.latitudeTextField.text
        let longitude = self.longitudeTextField.text
        let isLocationDefualt = self.isLocationDefaultSwitch.isOn
        
        
        if isLocationDefualt{
            self.changeDefault()
        }
        
        let location = LocationRealm(name: name!,
                                     latitude: latitude!,
                                     longitude: longitude!,
                                     isDefault: isLocationDefualt)
        
        try! DataManagerRealm.realm.write{
            DataManagerRealm.realm.add(location, update: .all)
        }
        
        self.savedSuccesfully(action: "added")
    }
    
    func savedSuccesfully(action:String){
        let message = Snackbar.init(text: "Location was successfully \(action)!", view: self.view)
        message.wrapperView.backgroundColor = .green
        message.show(stayTime: 3, showTime: 1, hideTime: 1, maxAlpha: 1)
        
        self.locationNameTextField.text = ""
        self.latitudeTextField.text = ""
        self.longitudeTextField.text = ""
        self.isLocationDefaultSwitch.isOn = false
        
        NotificationCenter.default.post(name: .locationsModified, object: nil)
    }
    
    func changeDefault(){
        guard let oldDefaultLocation = DataManagerRealm.realm.objects(LocationRealm.self).filter("isDefault == true").first
        else{
            return
        }
        
        try! DataManagerRealm.realm.write{
            oldDefaultLocation.isDefault = false
        }
    }
}
