//
//  CurrentWxVC.swift
//  SimplyWeather
//
//  Created by Michael Kroth on 2/14/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWxVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentCondition: UILabel!
    @IBOutlet weak var currentPressure: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    //@IBOutlet weak var currentMin: UILabel!
    //@IBOutlet weak var currentMax: UILabel!
    @IBOutlet weak var currentWinds: UILabel!
    @IBOutlet weak var currentSunset: UILabel!
    @IBOutlet weak var currentSunrise: UILabel!
    @IBOutlet weak var currentCityName: UILabel!
    @IBOutlet weak var currentWxIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var forecastArray = [[String: AnyObject]]()
    let client = OpenWxClient()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        locationAuthStatus()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        let forecast = forecastArray[indexPath.row]
        cell.dayOfWeek.text = forecast["dayOfWeek"] as! String?
        cell.highTemp.text = forecast["dayHigh"] as! String?
        cell.lowTemp.text = forecast["dayLow"] as! String?
        cell.forecastLabel.text = forecast["condition"] as! String?
        cell.iconImage.image = UIImage(named: (forecast["icon"] as! String?)!)
        return cell
    }
    
    func updateCurrentWxUI() {
        
        currentTemp.text = UserDefaults.standard.string(forKey: "currentTemp")! + "°"
        currentCondition.text = UserDefaults.standard.string(forKey: "currentWx")
        currentPressure.text = "Pressure: " + UserDefaults.standard.string(forKey: "currentPressure")! + " in"
        currentHumidity.text = "Humidity: " + String(UserDefaults.standard.double(forKey: "currentHumidity")) + " %"
        //currentMin.text = String(UserDefaults.standard.double(forKey: "currentHigh"))
        //currentMax.text = String(UserDefaults.standard.double(forKey: "currentLow"))
        currentWinds.text = "Winds: " + UserDefaults.standard.string(forKey: "currentWindDir")! + "° @ " + UserDefaults.standard.string(forKey: "currentWindSpeed")! + " mph"
        currentSunrise.text = "Sunrise: " + UserDefaults.standard.string(forKey: "currentSunrise")! + "   Sunset: " + UserDefaults.standard.string(forKey: "currentSunset")!
        currentCityName.text = UserDefaults.standard.string(forKey: "city")
        let icon = UserDefaults.standard.string(forKey: "currentWxIcon")!
        currentWxIcon.image = UIImage(named: icon)
        
    }
    
    func updateForeCastTable() {
        forecastArray = UserDefaults.standard.array(forKey: "forecastArray") as! [[String : AnyObject]]
        //print(forecastArray)
        tableView.reloadData()
    }
    
    func locationAuthStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            let latitude = currentLocation.coordinate.latitude
            let longitude = currentLocation.coordinate.longitude
            //print(currentLocation)
            UserDefaults.standard.set(latitude, forKey: "latitude")
            UserDefaults.standard.set(longitude, forKey: "longitude")
            UserDefaults.standard.synchronize()
            self.downloadWeather()
        } else {
            locationManager.requestWhenInUseAuthorization()
            currentLocation = locationManager.location
        }
    }
    
    func downloadWeather() {
        
        client.getCurrentWx { (success, error) in
            if success {
                self.updateCurrentWxUI()
            } else {
                print(error.debugDescription)
            }
        }
        client.getForecast { (success, error) in
            if success {
                // self.updateUI()
                //print("Success forcst")
                self.updateForeCastTable()
                
            } else {
                print(error.debugDescription)
            }
        }
    }


}
