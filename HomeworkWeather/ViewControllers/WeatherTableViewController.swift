//
//  WeatherTableViewController.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 18.01.23.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    let loadingString = "Loading..."
    let noDataString = "No data!"
    let unknownWeatherCode = "Error: Unknow weather code!"
    var location:LocationRealm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.location = DataManagerRealm.realm.objects(LocationRealm.self).filter("isDefault == true").first
        RequestManager.fetchDataAlamofire(location: self.location, completion: self.tableView.reloadData)
        
        NotificationCenter.default.addObserver(forName: .locationsModified,
                                               object: nil,
                                               queue: nil){
            _ in
            self.location = DataManagerRealm.realm.objects(LocationRealm.self).filter("isDefault == true").first
            RequestManager.fetchDataAlamofire(location: self.location, completion: self.tableView.reloadData)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.location = DataManagerRealm.realm.objects(LocationRealm.self).filter("isDefault == true").first
        RequestManager.fetchDataAlamofire(location: self.location, completion: self.tableView.reloadData)
        if self.location == nil {
            let settingViewController = self.tabBarController?.viewControllers?.first {$0.restorationIdentifier == "SettingsNavigationController"}
            self.tabBarController?.selectedViewController = settingViewController
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .locationsModified, object: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 8
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
           
        switch section {
        case 0:
            label.text = self.location?.name ?? "Loading..."
        case 1:
            label.text =  "Temperature:"
        case 2:
            label.text =  "Humidity:"
        case 3:
            label.text =  "Pressure:"
        case 4:
            label.text =  "Wind direction:"
        case 5:
            label.text =  "Wind speed:"
        case 6:
            label.text =  "Visability:"
        default:
            return nil
        }
            label.textAlignment = .center

            return label
        }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CenteredTableViewCell
        cell.textLabel?.text = "Loading..."
        cell.textLabel?.textAlignment = .center
        cell.imageView?.image = nil
        guard let weather = self.location?.weather
        else {
            return cell
        }
        
        switch indexPath.section{
        case 0:
            guard let weatherCondition = WeatherCode.getWeatherCondition(code: weather.weathercode)
            else{
                print(self.unknownWeatherCode)
                return cell
            }
            cell.textLabel?.text = String(weatherCondition.description)
            cell.imageView?.image = weatherCondition.image
        case 1:
            cell.textLabel?.text  = String(weather.temperature) + UserSettings.temperatureUnit!
        case 2:
            cell.textLabel?.text = String(Int(weather.humidity)) + "%"
         case 3:
            cell.textLabel?.text = String(Int(weather.pressure)) + "hPa"
        case 4:
            cell.textLabel?.text = String(weather.winddirection) + "°"
        case 5:
            cell.textLabel?.text = String(weather.windspeed) + "kmh"
        case 6:
            cell.textLabel?.text =  String(Int(weather.visibility)) + "m"
        case 7:
            cell.textLabel?.text = "Last updated: " + weather.lastUpdated
        default:
            return cell
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 96 : 64
    }
}

