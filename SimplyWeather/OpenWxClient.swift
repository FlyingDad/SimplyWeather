//
//  OpenWxClient.swift
//  SimplyWeather
//
//  Created by Michael Kroth on 2/13/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class OpenWxClient {
    
    
    func getCurrentWx(completed: @escaping (_ result: Bool, _ error: NSError?) -> Void) {
        
        
        let methodParameters = [
            OpenWxConstants.ParameterKeys.Zip: "65738",
            OpenWxConstants.ParameterKeys.Units: OpenWxConstants.ParameterValues.UnitsImperial,
            OpenWxConstants.ParameterKeys.APPID: OpenWxConstants.ParameterValues.APIKEY
        ]
        
        let urlString = OpenWxConstants.Url.BaseURl + OpenWxConstants.Method.CurrentWx
        //let url = URL(string: urlString + escapedParameters(parameters: methodParameters))!
        let url = urlString + escapedParameters(parameters: methodParameters)
        //print(url)
        Alamofire.request(url).responseJSON { response in
            
            if let json = response.result.value {
                let json = JSON(json)
                self.parseCurrentWx(json: json)
                completed(true, nil)
            } else {
                completed(false, NSError(domain: "getCurrentWx", code: 0, userInfo: nil))
            }
        }
    }
    
    func parseCurrentWx(json: JSON){
        
        let city = json[OpenWxConstants.ResponseKeys.CityName].string?.capitalized
        UserDefaults.standard.set(city, forKey: "city")
        let cityId = json[OpenWxConstants.ResponseKeys.CityId].int
        UserDefaults.standard.set(cityId, forKey: "cityId")
        if let currentWxDict = json[OpenWxConstants.ResponseKeys.WeatherConditionArray][0].dictionary {
            let currentWx = currentWxDict[OpenWxConstants.ResponseKeys.CurrentCondition]?.string?.capitalized
            let currentWxIcon = currentWxDict[OpenWxConstants.ResponseKeys.CurrentConditionIcon]?.string
            UserDefaults.standard.set(currentWx, forKey: "currentWx")
            UserDefaults.standard.set(currentWxIcon, forKey: "currentWxIcon")
        }
        if let currentMeasurements = json[OpenWxConstants.ResponseKeys.CurrentCondition].dictionary {
            let currentTemp = currentMeasurements[OpenWxConstants.ResponseKeys.CurrentTemp]?.double
            let currentPressure = currentMeasurements[OpenWxConstants.ResponseKeys.CurrentPressure]?.double
            let currentHumidity = currentMeasurements[OpenWxConstants.ResponseKeys.CurrentHumidity]?.double
            let currentHigh = currentMeasurements[OpenWxConstants.ResponseKeys.CurrentHigh]?.double
            let currentLow = currentMeasurements[OpenWxConstants.ResponseKeys.CurrentLow]?.double
            UserDefaults.standard.set(currentTemp, forKey: "currentTemp")
            UserDefaults.standard.set(currentPressure, forKey: "currentPressure")
            UserDefaults.standard.set(currentHumidity, forKey: "currentHumidity")
            UserDefaults.standard.set(currentHigh, forKey: "currentHigh")
            UserDefaults.standard.set(currentLow, forKey: "currentLow")
        }
        if let currentWindsDict = json[OpenWxConstants.ResponseKeys.CurrentWind].dictionary {
            let currentWindDir = currentWindsDict[OpenWxConstants.ResponseKeys.CurrentWindDir]?.double
            let currentWindSpeed = currentWindsDict[OpenWxConstants.ResponseKeys.CurrentWindSpeed]?.double
            UserDefaults.standard.set(currentWindDir, forKey: "currentWindDir")
            UserDefaults.standard.set(currentWindSpeed, forKey: "currentWindSpeed")
        }
        if let systemDict = json[OpenWxConstants.ResponseKeys.SystemDict].dictionary {
            let currentSunset = systemDict[OpenWxConstants.ResponseKeys.Sunset]?.int
            let currentSunrise = systemDict[OpenWxConstants.ResponseKeys.Sunrise]?.int
            UserDefaults.standard.set(currentSunset, forKey: "currentSunset")
            UserDefaults.standard.set(currentSunrise, forKey: "currentSunrise")
        }
        UserDefaults.standard.synchronize()
        
    }
    
    private func escapedParameters(parameters: [String: Any]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            // Make sure value is a string
            for (key, value) in parameters {
                let stringValue = "\(value)"
                
                // Escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                
                // Append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }

    
}
