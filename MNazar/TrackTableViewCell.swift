//
//  LocationTableViewCell.swift
//  MNazar
//
//  Created by Aditya Dwivedi on 1/30/17.
//  Copyright © 2017 org.adiproject. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    var timeLabel: UILabel!
    var distanceLabel: UILabel!
    var logoImageView: UIImageView!
    var timeColorImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white.withAlphaComponent(0.25)
        
        timeLabel = UILabel()
        distanceLabel = UILabel()
        
        logoImageView = UIImageView()
        logoImageView.clipsToBounds = true
        logoImageView.image = UIImage(named: "location_logo")
        
        timeColorImageView = UIImageView()
        
        timeLabel.textColor = .darkGray
        timeLabel.text = "At: "
        
        addSubview(timeLabel)
        addSubview(distanceLabel)
        addSubview(logoImageView)
        addSubview(timeColorImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timeLabel.frame = CGRect(x: frame.width*0.20, y: 0, width: frame.width*0.5, height: frame.height*0.5)
        distanceLabel.frame = CGRect(x: frame.width*0.20, y: frame.height*0.5, width: frame.width*0.5, height: frame.height*0.5)
        
        logoImageView.frame =  CGRect(x: frame.width*0.05, y: 0, width: frame.width*0.1, height: frame.height*0.5)
        logoImageView.center.y = frame.height*0.5
        
        timeColorImageView.frame =  CGRect(x: frame.width*0.85, y: 0, width: frame.width*0.125, height: frame.width*0.125)
        timeColorImageView.layer.cornerRadius = 10.0
        timeColorImageView.center.y = frame.height*0.5
    }
    
    func setup(labelDate: Date, colorcodeTime: Int, distance: String) {
        let requestedComponents: Set<Calendar.Component> = [.hour, .minute]
        let timeComponents = Calendar.current.dateComponents(requestedComponents, from: labelDate)
        var label = ""
        if let hours = timeComponents.hour {
            label += hours/10 < 1 ? "0" + String(hours) : String(hours)
        }
        if let minutes = timeComponents.minute {
            label += minutes/10 < 1 ? ":0" + String(minutes) : ":" + String(minutes)
        }
        timeLabel.text = "At "+label
        distanceLabel.text = "Distance: "+distance
        if colorcodeTime <= 2 {
            timeColorImageView.backgroundColor = .green
        }
        else if colorcodeTime <= 4 {
            timeColorImageView.backgroundColor = .yellow
        }
        else {
            timeColorImageView.backgroundColor = .red
        }
    }
    
}

