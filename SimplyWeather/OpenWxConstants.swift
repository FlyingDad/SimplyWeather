//
//  OpenWxConstants.swift
//  SimplyWeather
//
//  Created by Michael Kroth on 2/13/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import Foundation


struct OpenWxConstants {
    
    
    struct Url {
        
        static let BaseURl = "http://api.openweathermap.org/data/2.5/"
        
    }

    struct Method {
        
        static let CurrentWx = "weather"
        static let Forecast = "forecast/daily"
        
    }

    struct ParameterKeys {
        
        static let APPID = "APPID"
        static let CityName = "q="
        static let CityId = "id"
        static let Units = "units"
        static let Zip = "zip"
        static let ForecastCount = "cnt"
        static let longitude = "lon"
        static let latitude = "lat"
        
    }

    struct ParameterValues {
        
        static let APIKEY = "42bd00fbe08ea8184d5edbe2bdf8da54"
        static let UnitsImperial = "imperial"
        static let UnitsCelcius = "metric"
        static let ForecastCountDays = "7"
        
    }

    struct ResponseKeys {
        
        static let WeatherConditionArray = "weather"  // Array of one dict
        static let CurrentCondition = "main"
        static let CurrentConditionIcon = "icon"
        static let CurrentValuesDict = "main"   // Dict
        static let CurrentTemp = "temp"
        static let CurrentPressure = "pressure"
        static let CurrentHumidity = "humidity"
        static let CurrentHigh = "temp_max"
        static let CurrentLow = "temp_min"
        static let CityName = "name"
        static let CityId = "id"
        static let CurrentWind = "wind"
        static let CurrentWindSpeed = "speed"
        static let CurrentWindDir = "deg"
        static let SystemDict = "sys" // Dict
        static let Sunrise = "sunrise"
        static let Sunset = "sunset"
        
        // forecast responses
        static let Forecastdays = "list"
        static let Forecastdate = "dt"
        static let ForecastTemps = "temp"
        static let ForecastdaytimeTemp = "day"
        static let ForecastdayLow = "min"
        static let ForecastdayHigh = "max"
        static let ForecastWeather = "weather"
        static let ForecastCondition = "main"
        static let ForecastIcon = "icon"
        
    }

    struct ResponseValues {
        
    }
}
