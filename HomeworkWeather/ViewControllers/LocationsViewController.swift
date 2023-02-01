//
//  LocationsViewController.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 24.01.23.
//

import UIKit

class LocationsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showCurrentLocation()
        
        NotificationCenter.default.addObserver(forName: .locationsModified, object: nil, queue: nil){
            _ in
            self.showCurrentLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .locationsModified, object: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func showCurrentLocation(){
        guard let location = DataManagerRealm.realm.objects(LocationRealm.self).filter("isDefault == true").first
        else {
            self.nameLabel.text = "no set"
            self.latitudeLabel.text = "Latitude:\n" + "no set" + " °N"
            self.longitudeLabel.text = "Longitude:\n" + "no set" + " °E"
            return
        }
        self.nameLabel.text = location.name
        self.latitudeLabel.text = "Latitude:\n" + location.latitude + " °N"
        self.longitudeLabel.text = "Longitude:\n" + location.longitude + " °E"
    }
}
