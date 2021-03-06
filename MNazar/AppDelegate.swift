//
//  AppDelegate.swift
//  MNazar
//
//  Created by Aditya Dwivedi on 1/26/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit
import  CoreLocation
import GoogleMaps
import SystemConfiguration

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager!
    //var loggedIn: Bool = false
    var locationStackTop : Int = -1
    
    var lastLoggedLocation: CLLocation!

    var trackViewController: TrackViewController!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyDCmOU4HNWGOVTSawLPQgu7_LbAJC0GwwI")
        window = UIWindow()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        
        trackViewController = TrackViewController()
        trackViewController .locationManager = locationManager
        let navigationController = UINavigationController(rootViewController:trackViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    /*
     * Gets difference between two Date objects in hours
     */
    func getHourDifference(date1: Date, date2: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date1, to: date2).hour ?? 0
    }
    
    /*
     * Gets difference between two Date objects in seconds
     */
    func getSecondDifference(date1: Date, date2: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date1, to: date2).second ?? 0
    }
    
    /*
     * Called whenever phone receives a location
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Check if it's time to auto logout
            if trackViewController.checkForEndTime(date: location.timestamp) {
                if locationStackTop == trackViewController.sizeOfList()-1 {
                    trackViewController.logout()
                    trackViewController.populateResponseLabel(code: 2)
                    return
                }
            }
            if trackViewController.loggedIn {
                let hourDiff = abs(getHourDifference(date1: location.timestamp, date2: lastLoggedLocation.timestamp))
                let distance = location.distance(from: lastLoggedLocation)
                if hourDiff >= 1 || distance >= 100 {
                    if locationManager.desiredAccuracy == kCLLocationAccuracyNearestTenMeters {
                        toggleAccuracy()
                    }
                    else {
                        updateLocation(location: location, distance: distance, hourDiff: hourDiff)
                        toggleAccuracy()
                    }
                }
            } else {
                trackViewController.loggedIn = true
                updateLocation(location: location, distance: 0, hourDiff: 0)
            }
        }
    }
    
    /*
     * Checks properties of location and either adds to time spent if there is no significant change
     * or logs a new location
     * Sends data to server only if interent is connected
     * locationStackTop stores index in locationList upto which data has been sent to the server
     */
    func updateLocation(location: CLLocation, distance: CLLocationDistance, hourDiff: Int) {
        
        // returns if location is a cached location
        if let lastLocation = lastLoggedLocation {
            if getSecondDifference(date1: lastLocation.timestamp, date2: location.timestamp)<1 {
                return
            }
        }
        
        if distance <= 100 && hourDiff >= 1 {
            if let location1 = trackViewController.locationList.last {
                location1.timeAtLocation += hourDiff
                print(location1.timeAtLocation)
            }
        } else {
                if distance >= 100 {
                trackViewController.totalDistance += distance
            }
            trackViewController.locationList.append(LocationData(location: location, distanceTravelled: trackViewController.totalDistance))
            print("Location updated")
        }
        
        // Sends locally stored data to server only when interent is connected
        // location
        if isConnectedToInternet() {
            while locationStackTop < trackViewController.sizeOfList()-1 {
                locationStackTop += 1
                if let location1 = trackViewController.locationList[locationStackTop].location {
                    // sendDataToServer(location: location1)
                }
            }
        }
        
        lastLoggedLocation = location
        trackViewController.reloadTable()
    }
    
    
    /*
     * Code for pushing data to server
     * Call to function is commented out as developer does not have functioning server.
     */
    func sendDataToServer(location: CLLocation, locationList: [LocationData]!) {
        
        var timeAtPlace = 0
        if let lastLocation = locationList.last {
            timeAtPlace = lastLocation.timeAtLocation
        }
        
        let dataDict = ["Employee code:": trackViewController.employeeCode, "location-latitude": String(describing: location.coordinate.latitude), "location-longitude": String(describing: location.coordinate.longitude), "timeStamp": String(describing: location.timestamp), "distance": String(describing: trackViewController.totalDistance), "timeAtPlace": String(timeAtPlace)] as Dictionary<String, String>
        let jsonObj: Data
        
        if let url = URL(string: "serverURL") {
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            do {
                jsonObj = try JSONSerialization.data(withJSONObject: dataDict, options: [])
                request.httpBody = jsonObj
            } catch {
                print("Cannot create JSON object")
            }
            
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let err = error {
                    print("Error calling POST")
                    print(err)
                }
                if let dataResponse = data {
                    do {
                        if let objJson = try JSONSerialization.jsonObject(with: dataResponse, options: .mutableContainers) as? [String: Any] {
                            print(objJson)
                        }
                    } catch {
                        print("Error in processing data response")
                    }
                }
            })
            task.resume()
        }
    }
    
    /*
     * Returns true if device is connected to the internet
     * THe code in this function has been taken after some modification from
     * https://github.com/Isuru-Nanayakkara/Reach/blob/master/Reach-swift3.0/Reach.swift
     * THe original code has been licensed under the MIT license and is free to use as is.
     */
    func isConnectedToInternet() -> Bool {
        var address0 = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        address0.sin_len = UInt8(MemoryLayout<sockaddr_in>.size(ofValue: address0))
        address0.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &address0, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        
        if !connectionRequired && isReachable {
            return true
        } else {
            return false
        }
    }
    
    /*
     * Toggles accuracy of CLLocationManager for power optimization
     */
    func toggleAccuracy() {
        switch locationManager.desiredAccuracy {
        case kCLLocationAccuracyBest:
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            break
        case kCLLocationAccuracyNearestTenMeters:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        default: break
        }
    }
    
    
    //testing only
    func getMinuteDifference(date1: Date, date2: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date1, to: date2).minute ?? 0
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

