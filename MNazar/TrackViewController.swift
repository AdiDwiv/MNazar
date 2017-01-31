//
//  TrackViewController.swift
//  MNazar
//
//  Created by Aditya Dwivedi on 1/26/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit
import CoreLocation

class TrackViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var textView: UITextView!
    //---====----
    var locationManager: CLLocationManager!
    
    var locationTableView: UITableView!
    var locationList: [LocationData]! = []
    var totalDistance: CLLocationDistance = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your locations"
        view.backgroundColor = .white
        locationTableView = UITableView(frame: view.frame)
        locationTableView.dataSource = self
        locationTableView.delegate = self
        locationTableView.tableFooterView = UIView()
        locationTableView.rowHeight = view.frame.height*0.125
        
        view.addSubview(locationTableView)
        locationManager.startUpdatingLocation()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TrackTableViewCell(style: .default, reuseIdentifier: "Reuse")
        let size = locationList.count
        let locationData = locationList[size-indexPath.row-1]
        cell.setup(labelDate: locationData.location.timestamp, colorcodeTime: locationData.timeAtLocation, distance: String(describing: locationData.distanceTravelled))
        return cell
    }
    
    func reloadTable() {
        locationTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
