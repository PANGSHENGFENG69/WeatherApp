//
//  WeatherManager.swift

//
//  Created by PSF

// API TUTORIAL HERE BY PSF :  Units of measurement have 3 kinds : Standard,metric and imperial. I use metric for 簡單理解//
// 然後3個都有不同的叫法， 如果你要 Standard的話：就 &units=metric / &units=imperial ,如果是standard的話就看回去 API Docs 裏面有解釋，我只是懶得寫在這，不好意思

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel)
    func didFailWithError(error:Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=fa841cfc8dd86e4f7ba5fbd9eef6f0dd&units=metric"
    //Give a variable for store URL API call
    
    var delegate :WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)";
        performRequest(with: urlString)
    } //Fetch user data , and print out the user data FOR US
    
    func fecthWeather(latitude: CLLocationDegrees,longitude:CLLocationDegrees ){
        let urlString = "\(weatherURL)&lat= \(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString:String){
        
        //1.Create a URL first
        if let url = URL(string: urlString){
            
            //2.Create a urlSession
            let session = URLSession(configuration: .default)
            
            //3.Give Sesssion a task to tell him what u requesting for and what is the response back
            let task =  session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON (safeData){
                        self.delegate?.didUpdateWeather(self,weather:weather)
                        
                    }
                }
            }
                
                //4.Start a task //Why use resume()? Here Explain:Newly-initialized tasks begin in a suspended state, so you need to call this method to start the task.
                
                task.resume()
            }
            
        }
        //Parse JSON to Swift Object
        
        func parseJSON(_ weatherData: Data) -> WeatherModel?{
            let decoder = JSONDecoder() //From WeatherData.swift
            do{
                let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                let id = decodedData.weather[0].id
                let temp = decodedData.main.temp
                let name = decodedData.name
                
                let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
                
                return weather
                
            } catch{
                delegate?.didFailWithError(error: error)
                return nil
            }
            
        }
        
    }

