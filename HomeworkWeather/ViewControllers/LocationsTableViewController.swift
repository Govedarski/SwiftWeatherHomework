//
//  LocationTableViewController.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 25.01.23.
//

import UIKit
import RealmSwift

class LocationsTableViewController: UITableViewController {
    var locations:[LocationRealm]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTable()
        NotificationCenter.default.addObserver(forName: .locationsModified, object: nil, queue: nil){
            _ in
            print("table")
            self.updateTable()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .locationsModified, object: nil)
    }
    
    func updateTable(){
        let sortProperties = [SortDescriptor(keyPath: "isDefault", ascending: false), SortDescriptor(keyPath: "name", ascending: true)]
        self.locations = Array(DataManagerRealm.realm.objects(LocationRealm.self).sorted(by: sortProperties))
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.locations.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let currentLocation = self.locations[indexPath.section]
        cell.textLabel?.text = currentLocation.name
        cell.detailTextLabel?.text = "(\(currentLocation.latitude)  °N \(currentLocation.longitude) °E)"
        cell.imageView?.image = UIImage(systemName: "building.2.crop.circle")
        
        if currentLocation.isDefault {
            cell.imageView?.image = UIImage(systemName: "star.fill")
        }
        
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = self.locations[indexPath.section]
        
        let alert = UIAlertController(title: location.name, message: "(\(location.latitude) °N \(location.longitude)  °E)" , preferredStyle: .alert)
        let setDefaultLocationAction = UIAlertAction(title: "set as default", style: .default){
            _ in
            let defaultLocation = self.locations[0]
            try! DataManagerRealm.realm.write{
                defaultLocation.isDefault = false
                location.isDefault = true
            }
            NotificationCenter.default.post(name: .locationsModified, object: nil)
        }
        
        let deleteAction = UIAlertAction(title: "delete", style: .default){
            _ in
            try! DataManagerRealm.realm.write{
                DataManagerRealm.realm.delete(location)
            }
            NotificationCenter.default.post(name: .locationsModified, object: nil)
        }
        
        let editAction = UIAlertAction(title: "edit", style: .default){
            _ in
            let editLocationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
                editLocationVC.editedLocation = location
                self.present(editLocationVC, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .default)
        
        alert.addAction(setDefaultLocationAction)
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

}
