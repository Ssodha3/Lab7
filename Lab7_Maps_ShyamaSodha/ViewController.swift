//
//  ViewController.swift
//  Lab7_Maps_ShyamaSodha
//
//  Created by user237598 on 3/14/24.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var currentSpeedL: UILabel!
    @IBOutlet weak var maxSpeedL: UILabel!
    @IBOutlet weak var avgSpeedL: UILabel!
    @IBOutlet weak var distanceL: UILabel!
    @IBOutlet weak var maxAccelerationL: UILabel!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var greenGreyView: UIView!
    
    let locManager = CLLocationManager()
    var tripActive = false
    
    var startTime: Date?
    var lastLoc: CLLocation?
    var maxSpeed: CLLocationSpeed = 0
    var tDistance: CLLocationDistance = 0
    var tSpeed: CLLocationSpeed = 0
    var acceleration: Double = 0
    var distanceBeforeSL: CLLocationDistance = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentSpeedL.isHidden = true
        maxSpeedL.isHidden = true
        avgSpeedL.isHidden = true
        distanceL.isHidden = true
        maxAccelerationL.isHidden = true
        
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        redView.backgroundColor = UIColor.clear
        greenGreyView.backgroundColor = UIColor.gray
    }
    
    @IBAction func startBtn(_ sender: Any) {
        tripActive = true
        locManager.startUpdatingLocation()
        greenGreyView.backgroundColor = UIColor.green
    }
    
    @IBAction func stopBtn(_ sender: Any) {
        locManager.stopUpdatingLocation()
        tripActive = false
        greenGreyView.backgroundColor = UIColor.gray
        
        //distace covered before speed limit
        if distanceBeforeSL == 0{
            let distCovered = tDistance / 1000
            print("Distance covered before Speed was 115km/h: \(distCovered) km")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{
            return
        }
        
        currentSpeedL.isHidden = false
        maxSpeedL.isHidden = false
        avgSpeedL.isHidden = false
        distanceL.isHidden = false
        maxAccelerationL.isHidden = false
        
        let speed = location.speed
        currentSpeedL.text = String(format: "%.2f km/h", speed)
        
        if speed > 115{
            redView.backgroundColor = UIColor.red
        }else{
            redView.backgroundColor = UIColor.clear
        }
        
        //mapView Driver Location Show
        mapView.showsUserLocation = true
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        if let finalLoc = lastLoc{
            let timeDiff = location.timestamp.timeIntervalSince(finalLoc.timestamp)
            let distance = location.distance(from: finalLoc)
            let speed = distance / timeDiff
            
            if location.speed > maxSpeed{
                maxSpeed = location.speed
                maxSpeedL.text = String(format: "%.2f km/h", maxSpeed)
            }
//
//            //maxSpeed
//            maxSpeed = max(maxSpeed, location.speed)
//            maxSpeedL.text = String(format: "%.2f km/h", maxSpeed)

            //total distance
            tDistance += distance
            distanceL.text = String(format: "%.2f km/h",tDistance/1000)
            
            //total speed
            tSpeed += speed
            avgSpeedL.text = String(format: "%.2f km/h",tSpeed/(tDistance/1000))
            
            //acceleration
            let speedDiff = speed - finalLoc.speed
            let timeChage = timeDiff
            if timeChage != 0{
                acceleration = abs(speedDiff / timeChage)
            }
            
            maxAccelerationL.text = String(format: "%.3f m/s^2", acceleration)
            
            //distatance before speed limit
            if speed > 115  && distanceBeforeSL == 0{
                distanceBeforeSL = tDistance
            }
        }
        lastLoc = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("sorry enable to load! error with location manager.")
        }
}

