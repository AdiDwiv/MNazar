//
//  LocationData.swift
//  MNazar
//
//  Created by Aditya Dwivedi on 1/30/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import Foundation
import CoreLocation

class LocationData {

    var location: CLLocation!
    var timeAtLocation: Int
    var distanceTravelled: CLLocationDistance
    
    init(location: CLLocation, distanceTravelled: CLLocationDistance) {
        self.location = location
        self.timeAtLocation = 0
        self.distanceTravelled = distanceTravelled
    }
}
