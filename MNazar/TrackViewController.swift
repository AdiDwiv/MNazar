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
    var empCodeTextField: UITextField!
    var passwordTextField: UITextField!
    var password: String!
    var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        title = "Login"
        view.backgroundColor = .white
        
        //post-login table
        locationTableView = UITableView(frame: view.frame)
        locationTableView.dataSource = self
        locationTableView.delegate = self
        locationTableView.tableFooterView = UIView()
        locationTableView.rowHeight = view.frame.height*0.125
        
        //pre-login screen
        logoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.75, height: view.frame.height*0.20))
        logoLabel.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.25)
        logoLabel.text = "mNazar"
        logoLabel.textColor = .blue
        logoLabel.font = UIFont.boldSystemFont(ofSize: 30)
        logoLabel.textAlignment = .center
        
        empCodeTextField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.85, height: view.frame.height*0.05))
        empCodeTextField.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.50)
        empCodeTextField.placeholder = "Employee code"
        empCodeTextField.layer.borderWidth = 0.25
        empCodeTextField.layer.cornerRadius = 8
        empCodeTextField.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        empCodeTextField.font = UIFont.boldSystemFont(ofSize: 16)
        empCodeTextField.delegate = self
        
        passwordTextField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.85, height: view.frame.height*0.05))
        passwordTextField.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.56)
        passwordTextField.placeholder = "Password"
        passwordTextField.layer.borderWidth = 0.25
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        passwordTextField.font = UIFont.boldSystemFont(ofSize: 16)
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(passwordFieldChanged), for: .editingChanged)
        password = ""
        
        loginButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.15, height: view.frame.height*0.05))
        loginButton.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.75)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .blue
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        view.addSubview(logoLabel)
        view.addSubview(empCodeTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.backgroundColor = .lightGray
    }
    
    func login() {
        var empCode = ""
        if let text1 = empCodeTextField.text {
            empCode = text1
        }
        if empCode.characters.count>0 && password.characters.count>0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.logoLabel.removeFromSuperview()
                self.empCodeTextField.removeFromSuperview()
                self.passwordTextField.removeFromSuperview()
                self.loginButton.removeFromSuperview()
                self.view.backgroundColor = .white
            }, completion: { _ in
                self.title = "Your locations"
                self.view.addSubview(self.locationTableView)
                self.locationManager.startUpdatingLocation()
            })
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapViewController = MapViewController()
        let size = locationList.count
        mapViewController.location = locationList[size-indexPath.row-1].location
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func reloadTable() {
        locationTableView.reloadData()
    }
    
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
}
