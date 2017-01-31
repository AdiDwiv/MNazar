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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager!
    var loggedIn: Bool = false
    
    var lastLoggedLocation: CLLocation!

    var trackViewController: TrackViewController!
    
    var textView: UITextView!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyDCmOU4HNWGOVTSawLPQgu7_LbAJC0GwwI")
        window = UIWindow()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        
        
        trackViewController = TrackViewController()
        trackViewController .locationManager = locationManager
        let navigationController = UINavigationController(rootViewController:trackViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        locationManager.stopUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }
    /*
     * Called whenever phone receives a location
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            if loggedIn {
                let hourDiff = getHourDifference(date1: lastLoggedLocation.timestamp, date2: location.timestamp)
                let distance = location.distance(from: lastLoggedLocation)
                if hourDiff >= 1 || distance >= 200 {
                    if locationManager.desiredAccuracy == kCLLocationAccuracyThreeKilometers {
                        toggleAccuracy()
                    }
                    else {
                        updateLocation(location: location, distance: distance, hourDiff: hourDiff)
                        toggleAccuracy()
                    }
                }
            } else {
                loggedIn = true
                updateLocation(location: location, distance: 0, hourDiff: 0)
            }
        }
    }
    
    /*
     * Checks properties of location and either adds to time spent if there is no significant change
     * or logs a new location
     */
    func updateLocation(location: CLLocation, distance: CLLocationDistance, hourDiff: Int) {
    
        if distance <= 200 && hourDiff >= 1 {
            if let location1 = trackViewController.locationList.last {
                location1.timeAtLocation += hourDiff
                print(location1.timeAtLocation)
            }
        } else {
                if distance >= 200 {
                trackViewController.totalDistance += distance
            }
            trackViewController.locationList.append(LocationData(location: location, distanceTravelled: trackViewController.totalDistance))
            lastLoggedLocation = location
            print("Location updated")
        }
        
       // sendDataToServer(location: location)
        
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
        
        let dataDict = ["location-latitude": String(describing: location.coordinate.latitude), "location-longitude": String(describing: location.coordinate.longitude), "timeStamp": String(describing: location.timestamp), "distance": String(describing: trackViewController.totalDistance), "timeAtPlace": String(timeAtPlace)] as Dictionary<String, String>
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
     * Toggles accuracy of CLLocationManager for power optimization
     */
    func toggleAccuracy() {
        switch locationManager.desiredAccuracy {
        case kCLLocationAccuracyBest:
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            break
        case kCLLocationAccuracyThreeKilometers:
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        default: break
        }
    }
    
    /*
     * Gets difference between two Date objects in hours
     */
    func getHourDifference(date1: Date, date2: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date1, to: date2).hour ?? 0
    }
    
    //testing only
    func getMinuteDifference(date1: Date, date2: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date1, to: date2).minute ?? 0
    }
    
    
    //testing only
    func getSecondDifference(date1: Date, date2: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date1, to: date2).second ?? 0
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

