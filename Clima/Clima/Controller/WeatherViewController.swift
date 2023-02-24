

import UIKit
import CoreLocation
//UITextFieldDelegate Is for let user input so need to import that shit
//I use Openweathermap.org for API call, and i add "JSON Viewer Awesome" Extension on google for looking good at these Object

class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()// This is "class" like new...()
    let locationManager = CLLocationManager() // LIKE GPS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //This function is like Allow or dont allow in app
        locationManager.requestLocation()
        
        
        weatherManager.delegate = self
        searchTextField.delegate = self // "self" refer to the current view controller
    }


}
extension WeatherViewController:UITextFieldDelegate{
    @IBAction func searchButton(_ sender: UIButton) {
        searchTextField.endEditing(true)// This Method is to let the keyboard lost
        
        print(searchTextField.text!); //Print out the user input
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) // This Method is to let the keyboard lost
        
        print(searchTextField.text!)
        return true;
    } //this function is "when user finished typing and press ENTER, what should this function do"
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true;
        }else{
            textField.placeholder = "Type Smth";
            return false
        }
    }
    //This Function is to let if user didnt type any thing, and give him a placeholder to tell him "Type Smth", or else the placeholder wont be lost
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        } // Use "if let" for optional binding
        
        searchTextField.text = "";
    }
}

extension WeatherViewController : WeatherManagerDelegate{
    // This function is when user finished their typing and press enter, and let the Text on search bar for lost
     func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel){
         DispatchQueue.main.async {
             self.temperatureLabel.text = weather.temperatureString
             self.conditionImageView.image = UIImage(systemName: weather.conditionName)
             self.cityLabel.text = weather.cityName // THIS PART IS WHEN USER TYPE WHAT LOCATION AND IT WILL CHANGE TO THAT LOCATION ,SO WONT BE ALWAYS SAME AS DEFAULT
         }
     }
     func didFailWithError(error: Error) { //show the error part
         print(error)
     }
}


// THIS PART IS LOCATION
extension WeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { //IF SUCCESS
        if let location = locations.last{
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fecthWeather(latitude:lat,longitude:lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { //IF FAILED
        print(error)
    }
}
