//
//  WeatherModel.swift

//
//  Created by PSF on 2023/2/24.
//

import Foundation

struct WeatherModel{
    let conditionId:Int
    let cityName :String
    let temperature:Double
    
    var temperatureString:String{
        return String(format:"%.1f",temperature) //For single decimal number
    }
    var conditionName:String{ //GET WEATHER CONDITION AND TEMP AND FOR THEIR SF SYMBOLS
        switch conditionId {
        case 200...232:
            return "Cloud.Bolt"
        case 300...321:
            return "Cloud.Drizzle"
        case 500...531:
            return "Cloud.Rain"
        case 600...622:
            return "Cloud.Snow"
        case 701...781:
            return "Cloud.Fog"
        case 800:
            return "Sun.Max"
        case 801...804:
            return "Cloud.Bolt"
        default:
            return "Cloud"
        }
    }
}
