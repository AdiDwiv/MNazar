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
        backgroundColor = UIColor.white.withAlphaComponent(0)
        
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
        timeLabel.frame = CGRect(x: frame.width*0.20, y: frame.height*0.225, width: frame.width*0.65, height: frame.height*0.25)
        timeLabel.font = UIFont.systemFont(ofSize: 17)
        timeLabel.minimumScaleFactor = 0.1
        timeLabel.adjustsFontSizeToFitWidth = true
        
        distanceLabel.frame = CGRect(x: frame.width*0.20, y: frame.height*0.5, width: frame.width*0.65, height: frame.height*0.5)
        distanceLabel.font = UIFont.systemFont(ofSize: 19)
        distanceLabel.minimumScaleFactor = 0.1
        distanceLabel.adjustsFontSizeToFitWidth = true
        
        logoImageView.frame =  CGRect(x: frame.width*0.05, y: 0, width: frame.width*0.1, height: frame.height*0.5)
        logoImageView.center.y = frame.height*0.5
        
        timeColorImageView.frame =  CGRect(x: frame.width*0.85, y: 0, width: frame.width*0.075, height: frame.width*0.075)
        timeColorImageView.layer.cornerRadius = timeColorImageView.bounds.size.width/2
        timeColorImageView.layer.masksToBounds = true
        timeColorImageView.center.y = frame.height*0.5
    }
    
    func setup(labelDate: Date, colorcodeTime: Int, distance: Int) {
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
        if distance < 1000 {
            distanceLabel.text = "Distance travelled: "+String(distance)+"m"
        } else {
            distanceLabel.text = "Distance travelled: "+String(distance/1000)+"km"
        }
        if colorcodeTime <= 1 {
            timeColorImageView.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        }
        else if colorcodeTime <= 3 {
            timeColorImageView.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        }
        else {
            timeColorImageView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        }
    }
    
}

