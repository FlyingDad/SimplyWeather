//
//  CurrentWxVC.swift
//  SimplyWeather
//
//  Created by Michael Kroth on 2/14/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit

class CurrentWxVC: UIViewController {

    
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentCondition: UILabel!
    @IBOutlet weak var currentPressure: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var currentMin: UILabel!
    @IBOutlet weak var currentMax: UILabel!
    @IBOutlet weak var currentWindSpeed: UILabel!
    @IBOutlet weak var currentWindDir: UILabel!
    @IBOutlet weak var currentSunset: UILabel!
    @IBOutlet weak var currentSunrise: UILabel!
    @IBOutlet weak var currentCityName: UILabel!
    @IBOutlet weak var currentWxIcon: UIImageView!
    
    let client = OpenWxClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.getCurrentWx { (success, error) in
            if success {
                self.updateUI()
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    func updateUI() {
        
        currentTemp.text = String(UserDefaults.standard.double(forKey: "currentTemp"))
        currentCondition.text = UserDefaults.standard.string(forKey: "currentWx")
        
        currentPressure.text = convertPressure(pressure: (UserDefaults.standard.double(forKey: "currentPressure")))
        currentHumidity.text = String(UserDefaults.standard.double(forKey: "currentHumidity")) + " %"
        currentMin.text = String(UserDefaults.standard.double(forKey: "currentHigh"))
        currentMax.text = String(UserDefaults.standard.double(forKey: "currentLow"))
        currentWindSpeed.text = String(UserDefaults.standard.double(forKey: "currentWindSpeed")) + " mph"
        currentWindDir.text = String(UserDefaults.standard.double(forKey: "currentWindDir"))
        currentSunset.text = String(UserDefaults.standard.integer(forKey: "currentSunset"))
        currentSunrise.text = String(UserDefaults.standard.integer(forKey: "currentSunrise"))
        currentCityName.text = UserDefaults.standard.string(forKey: "city")
        let icon = UserDefaults.standard.string(forKey: "currentWxIcon")!
        currentWxIcon.image = UIImage(named: icon)
        
    }
    
    func convertPressure(pressure: Double) -> String {
        
        let inches = pressure * 0.0295301
        return String(format: "%.2f", inches)
        
    }




}
