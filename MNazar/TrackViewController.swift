//
//  TrackViewController.swift
//  MNazar
//
//  Created by Aditya Dwivedi on 1/26/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit
import CoreLocation

class TrackViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var locationManager: CLLocationManager!
    
    var locationTableView: UITableView!
    var locationList: [LocationData]! = []
    var totalDistance: CLLocationDistance = 0
    
    var logoLabel: UILabel!
    var logoImageView: UIImageView!
    var empCodeTextField: UITextField!
    var passwordTextField: UITextField!
    var password: String!
    var loginButton: UIButton!
    
    var employeeCode: String!
    var colorPalette = ColorPalette()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = colorPalette.colorText
        
        navigationController?.navigationBar.barTintColor = colorPalette.colorPrimaryDarker
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colorPalette.colorText]
        tabBarController?.tabBar.barTintColor = colorPalette.colorPrimaryDark
        tabBarController?.tabBar.tintColor = colorPalette.colorTextBox
        
        //post-login table
        locationTableView = UITableView(frame: view.frame)
        locationTableView.dataSource = self
        locationTableView.delegate = self
        locationTableView.tableFooterView = UIView()
        locationTableView.rowHeight = view.frame.height*0.125
        locationTableView.backgroundColor = UIColor.white.withAlphaComponent(0)
        //pre-login screen
        logoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.80, height: view.frame.height*0.20))
        logoLabel.center = CGPoint(x: view.frame.width*0.40, y: view.frame.height*0.30)
        logoLabel.text = "mNazar"
        logoLabel.textColor = colorPalette.colorPrimaryDarker
        logoLabel.font = UIFont.boldSystemFont(ofSize: 65)
        logoLabel.backgroundColor = UIColor.white.withAlphaComponent(0)
        logoLabel.textAlignment = .center
        logoLabel.minimumScaleFactor = 0.1
        logoLabel.adjustsFontSizeToFitWidth = true
        
        logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.20, height: view.frame.height*0.10))
        logoImageView.center = CGPoint(x: view.frame.width*0.90, y: view.frame.height*0.30)
        logoImageView.image = UIImage(named: "location_logo.png")
        
        empCodeTextField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.85, height: view.frame.height*0.05))
        empCodeTextField.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.55)
        empCodeTextField.attributedPlaceholder =  NSAttributedString(string: " Employee code", attributes: [NSForegroundColorAttributeName: colorPalette.colorText.withAlphaComponent(0.85)])
        empCodeTextField.layer.borderWidth = 0.25
        empCodeTextField.layer.cornerRadius = 5
        empCodeTextField.backgroundColor = UIColor.white.withAlphaComponent(0.35)
       // empCodeTextField.font = UIFont.systemFont(ofSize: 16)
        empCodeTextField.delegate = self
        empCodeTextField.backgroundColor = colorPalette.colorPrimaryDarker
        empCodeTextField.textColor = colorPalette.colorText
        
        passwordTextField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.85, height: view.frame.height*0.05))
        passwordTextField.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.605)
        passwordTextField.attributedPlaceholder =  NSAttributedString(string: " Password", attributes: [NSForegroundColorAttributeName: colorPalette.colorText.withAlphaComponent(0.85)])
        passwordTextField.layer.borderWidth = 0.25
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.backgroundColor = UIColor.white.withAlphaComponent(0.35)
       // passwordTextField.font = UIFont.systemFont(ofSize: 16)
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(passwordFieldChanged), for: .editingChanged)
        passwordTextField.backgroundColor = colorPalette.colorPrimaryDarker
        passwordTextField.textColor = colorPalette.colorText
        password = ""
        
        loginButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.25, height: view.frame.height*0.075))
        loginButton.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.7125)
        loginButton.setTitleColor(colorPalette.colorText, for: .normal)
        loginButton.backgroundColor = colorPalette.colorPrimaryDarker
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        addLoginElements()
    }
    
    func login() {
        
        if let text1 = empCodeTextField.text {
            employeeCode = text1
        }
        if employeeCode.characters.count>0 && password.characters.count>0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.logoLabel.removeFromSuperview()
                self.empCodeTextField.removeFromSuperview()
                self.passwordTextField.removeFromSuperview()
                self.loginButton.removeFromSuperview()
                self.logoImageView.removeFromSuperview()
                self.view.backgroundColor = self.colorPalette.colorPrimary
            }, completion: { _ in
                self.title = "Your locations"
                UIView.animate(withDuration: 0.125, animations: {
                    self.view.backgroundColor = self.colorPalette.colorText
                })
                self.view.addSubview(self.locationTableView)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout))
                self.navigationItem.rightBarButtonItem?.tintColor = self.colorPalette.colorTextBox
                self.locationManager.startUpdatingLocation()
            })
        }
    }
    
    func addLoginElements() {
        empCodeTextField.text = ""
        passwordTextField.text = ""
        view.addSubview(logoLabel)
        view.addSubview(empCodeTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(logoImageView)
        title = "Login"
    }
    
    /* Logs user out and stops updating location
     */
    func logout() {
        UIView.animate(withDuration: 0.125, animations: {
            self.locationManager.stopUpdatingLocation()
            self.locationTableView.removeFromSuperview()
            self.view.backgroundColor = self.colorPalette.colorText
            self.navigationItem.rightBarButtonItem = nil
            self.view.backgroundColor = self.colorPalette.colorPrimary
        }, completion: { _ in
            self.password = ""
            self.employeeCode = ""
            UIView.animate(withDuration: 0.25, animations: {
                self.view.backgroundColor = self.colorPalette.colorText
            })
            self.addLoginElements()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TrackTableViewCell(style: .default, reuseIdentifier: "Reuse")
        let size = locationList.count
        let locationData = locationList[size-indexPath.row-1]
        cell.setup(labelDate: locationData.location.timestamp, colorcodeTime: locationData.timeAtLocation, distance: Int(locationData.distanceTravelled))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapViewController = MapViewController()
        let size = locationList.count
        mapViewController.locationData = locationList[size-indexPath.row-1]
        mapViewController.employeeCode = employeeCode
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func reloadTable() {
        locationTableView.reloadData()
    }
    
    /* Changes text in password field to ***
     */
    func passwordFieldChanged() {
        if let text = passwordTextField.text {
            password = text
            var length = text.characters.count
            var asteriskText = ""
            while length > 0 {
                asteriskText += "*"
                length -= 1
            }
            passwordTextField.text = asteriskText
        }
    }
    
    /* Logs user out at 7:00 PM
     */
    func checkForEndTime(date: Date) -> Bool {
        let requestedComponents: Set<Calendar.Component> = [.hour, .weekday]
        let timeComponents = Calendar.current.dateComponents(requestedComponents, from: date)
        if let hours = timeComponents.hour {
            if hours >= 19 {
                return true
            }
        }
        if let day = timeComponents.weekday {
            if day == 1 {
                return true
            }
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func sizeOfList() -> Int {
        return locationList.count
    }
}
