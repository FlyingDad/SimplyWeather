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
        
        let latitude = String(UserDefaults.standard.double(forKey: "latitude"))
        let longitude = String(UserDefaults.standard.double(forKey: "longitude"))

        let methodParameters = [
            //OpenWxConstants.ParameterKeys.Zip: "65738",
            OpenWxConstants.ParameterKeys.latitude: latitude,
            OpenWxConstants.ParameterKeys.longitude: longitude,

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
    
    func getForecast(completed: @escaping (_ result: Bool, _ error: NSError?) -> Void) {
        
        let latitude = String(UserDefaults.standard.double(forKey: "latitude"))
        let longitude = String(UserDefaults.standard.double(forKey: "longitude"))
    
        let methodParameters = [
            //OpenWxConstants.ParameterKeys.Zip: "65738",
            OpenWxConstants.ParameterKeys.latitude: latitude,
            OpenWxConstants.ParameterKeys.longitude: longitude,
            OpenWxConstants.ParameterKeys.Units: OpenWxConstants.ParameterValues.UnitsImperial,
            OpenWxConstants.ParameterKeys.ForecastCount: OpenWxConstants.ParameterValues.ForecastCountDays,
            OpenWxConstants.ParameterKeys.APPID: OpenWxConstants.ParameterValues.APIKEY
        ]
        
        let urlString = OpenWxConstants.Url.BaseURl + OpenWxConstants.Method.Forecast
        //let url = URL(string: urlString + escapedParameters(parameters: methodParameters))!
        let url = urlString + escapedParameters(parameters: methodParameters)
        //print(url)
        Alamofire.request(url).responseJSON { response in
            
            if let json = response.result.value {
                let json = JSON(json)
                //print(json)
                self.parseForecast(json: json)
                completed(true, nil)
            } else {
                completed(false, NSError(domain: "getForecast", code: 0, userInfo: nil))
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
            UserDefaults.standard.set(convertDoubleToString(number: currentTemp!, decimalPoints: 1), forKey: "currentTemp")
            let pressureString = (convertPressure(pressure: currentPressure!))
            UserDefaults.standard.set(pressureString, forKey: "currentPressure")
            UserDefaults.standard.set(currentHumidity, forKey: "currentHumidity")
            UserDefaults.standard.set(currentHigh, forKey: "currentHigh")
            UserDefaults.standard.set(currentLow, forKey: "currentLow")
        }
        if let currentWindsDict = json[OpenWxConstants.ResponseKeys.CurrentWind].dictionary {
            let currentWindDir = currentWindsDict[OpenWxConstants.ResponseKeys.CurrentWindDir]?.double
            let currentWindSpeed = currentWindsDict[OpenWxConstants.ResponseKeys.CurrentWindSpeed]?.double
            UserDefaults.standard.set(convertDoubleToString(number: currentWindDir!, decimalPoints: 0), forKey: "currentWindDir")
            UserDefaults.standard.set(convertDoubleToString(number: currentWindSpeed!, decimalPoints: 1), forKey: "currentWindSpeed")
        }
        if let systemDict = json[OpenWxConstants.ResponseKeys.SystemDict].dictionary {
            let currentSunset = systemDict[OpenWxConstants.ResponseKeys.Sunset]?.double
            let currentSunrise = systemDict[OpenWxConstants.ResponseKeys.Sunrise]?.double
            let sunsetString = convertUnixDatetoTime(unixTimestamp: currentSunset!)
            let sunriseString = convertUnixDatetoTime(unixTimestamp: currentSunrise!)
            //print(sunsetString)
            UserDefaults.standard.set(sunsetString, forKey: "currentSunset")
            UserDefaults.standard.set(sunriseString, forKey: "currentSunrise")
        }
        UserDefaults.standard.synchronize()
        
    }
    
    func parseForecast(json: JSON) {
        
        var forecastArray = [[String: AnyObject]]()
        
        if let forecastDays = json[OpenWxConstants.ResponseKeys.Forecastdays].array {
            
            //print(forecastDays?.count)
            
            for eachday in forecastDays {
                var dayDict = [String: AnyObject]()
                let date = eachday[OpenWxConstants.ResponseKeys.Forecastdate].double
                dayDict["dayOfWeek"] = self.convertUnixDatetoDay(unixTimestamp: date!) as AnyObject?
                
                
                guard let dailyTemps = eachday[OpenWxConstants.ResponseKeys.ForecastTemps].dictionary else {
                    print("Fail to get forecst temps")
                    return
                }
                let high = dailyTemps[OpenWxConstants.ResponseKeys.ForecastdayHigh]?.double
                let low = dailyTemps[OpenWxConstants.ResponseKeys.ForecastdayLow]?.double
                dayDict["dayHigh"] = convertDoubleToString(number: low!, decimalPoints: 0) as AnyObject?
                dayDict["dayLow"] = convertDoubleToString(number: high!, decimalPoints: 0) as AnyObject?
                
                guard let weatherArr = eachday[OpenWxConstants.ResponseKeys.ForecastWeather].array else {
                    print("Fail to get forecst weather")
                    return
                }
                let weatherDict = weatherArr[0]
                dayDict["condition"] = weatherDict[OpenWxConstants.ResponseKeys.ForecastCondition].string as AnyObject?
                dayDict["icon"] = weatherDict[OpenWxConstants.ResponseKeys.ForecastIcon].string as AnyObject?
                
                forecastArray.append(dayDict)
            }
            UserDefaults.standard.set(forecastArray, forKey: "forecastArray")
        }
    }
    
    func convertPressure(pressure: Double) -> String {
        
        let inches = pressure * 0.0295301
        return String(format: "%.2f", inches)
        
    }
    
    func convertDoubleToString(number: Double, decimalPoints: Int) -> String {
        return String(format: "%.\(decimalPoints)f" , number)
    }
    
    func convertUnixDatetoTime(unixTimestamp: Double) -> String {
        
        let convertedDate = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: convertedDate)

    }
    
    func convertUnixDatetoDay(unixTimestamp: Double) -> String {
        
        let convertedDate = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "EEEEEEE"
        return dateFormatter.string(from: convertedDate)
        
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
