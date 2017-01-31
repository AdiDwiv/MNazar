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

    var location: CLLocation!
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        let marker = GMSMarker()
        marker.position = location.coordinate
        marker.title = "Location"
        marker.snippet = "Loc"
        marker.map = mapView
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
