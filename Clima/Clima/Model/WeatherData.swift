//
//  WeatherData.swift

//
//  Created by PSF on 2023/2/24.
// Create This file for storing JSON , and parsing it
//Codable is a type alias for the Encodable and Decodable protocols 2選1

import Foundation

struct WeatherData:Codable{
    let name :String
    let main : Main
    let weather : [Weather] //Why put weather into array? because u have to see the description in JSON there
}
struct Main : Codable{
    let temp:Double
}

struct Weather :Codable {
    let description :String
    let id : Int
}
