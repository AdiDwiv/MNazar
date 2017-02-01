//
//  MapViewController.swift
//  MNazar
//
//  Created by Aditya Dwivedi on 1/31/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapViewController: UIViewController {

    var employeeCode: String!
    var locationData: LocationData!
    var colorPalette = ColorPalette()
    
    override func loadView() {
        title = "Map"
        
        navigationController?.navigationBar.barTintColor = colorPalette.colorPrimaryDarker
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colorPalette.colorText]
        tabBarController?.tabBar.barTintColor = colorPalette.colorPrimaryDark
        tabBarController?.tabBar.tintColor = colorPalette.colorTextBox
        navigationController?.navigationBar.tintColor = self.colorPalette.colorTextBox
        if let location = locationData.location {
            let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            view = mapView
            
            let marker = GMSMarker()
            marker.position = location.coordinate
            if locationData.timeAtLocation < 1 {
                marker.title = "Hours spent here: <1"
            } else {
                marker.title = "Hours spent here: "+String(locationData.timeAtLocation)
            }
            marker.snippet = "Employee code: "+employeeCode
            marker.map = mapView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
