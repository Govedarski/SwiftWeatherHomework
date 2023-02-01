//
//  SettingsTableViewController.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 24.01.23.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    var location:LocationRealm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.location = DataManagerRealm.realm.objects(LocationRealm.self).filter("isDefault == true").first
        self.tableView.reloadData()
        
        NotificationCenter.default.addObserver(forName: .locationsModified,
                                               object: nil,
                                               queue: nil){
            _ in
            self.location = DataManagerRealm.realm.objects(LocationRealm.self).filter("isDefault == true").first
            RequestManager.fetchDataAlamofire(location: self.location, completion: {})
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.location == nil{
            Snackbar(text: "Please set a default location in order to proceed with utilizing the application.", view: self.view)
            .show(stayTime: 3, showTime: 1, hideTime: 1)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .locationsModified, object: nil)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        switch indexPath.section{
        case 0:
            cell.imageView?.image = UIImage(systemName: "building.2.crop.circle")
            cell.textLabel?.text = "Location:"
            
            cell.detailTextLabel?.text = location != nil
            ? location!.name + " (\(location!.latitude)°N, \(location!.longitude)°E)"
            : "no location set"
        case 1:
            cell.imageView?.image = UIImage(systemName: "thermometer")
            cell.textLabel?.text = "Temperature unit:"
            cell.detailTextLabel?.text = UserSettings.temperatureUnit ?? "no unit set"
        default:
            return cell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            performSegue(withIdentifier: "ShowLocations", sender: cell)
        case 1:
            self.chooseTempUnit()
        default:
            return
        }
    }
    
    func chooseTempUnit() {
        let alert = UIAlertController(title: "Select Temperature Unit", message: nil, preferredStyle: .alert)

        let celsiusAction = UIAlertAction(title: "Celsius", style: .default) { _ in
            UserSettings.temperatureUnit = TemperatureUnit.Celsius.rawValue
            self.tableView.reloadData()
        }
        alert.addAction(celsiusAction)

        let fahrenheitAction = UIAlertAction(title: "Fahrenheit", style: .default) { _ in
            UserSettings.temperatureUnit = TemperatureUnit.Fahrenheit.rawValue
            self.tableView.reloadData()
        }
        alert.addAction(fahrenheitAction)

        self.present(alert, animated: true, completion: nil)
    }
}
