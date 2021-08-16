//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
     
     @IBOutlet weak var conditionImageView: UIImageView!
     @IBOutlet weak var temperatureLabel: UILabel!
     @IBOutlet weak var cityLabel: UILabel!
     
     var weatherManager = WeatherManager()
     let locationManager = CLLocationManager()
     
     @IBOutlet weak var searchTextField: UITextField!
     override func viewDidLoad() {
          super.viewDidLoad()
          // Do any additional setup after loading the view.
          locationManager.requestWhenInUseAuthorization()
          
          locationManager.delegate = self
          locationManager.requestLocation()
          
          searchTextField.delegate = self
          weatherManager.delegate = self
     }
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate{
     
     @IBAction func searchPressed(_ sender: UIButton) {
          searchTextField.endEditing(true)
          print(searchTextField.text!)
     }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          searchTextField.endEditing(true)
          print(searchTextField.text!)
          
          return true
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
          if let city = searchTextField.text {
               weatherManager.fetchWeather(cityName: city)
          }
          searchTextField.text = ""
     }
     
     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
          if textField.text != "" {
               return true
          }else{
               textField.placeholder = "Enter a City Name"
               return false
          }
     }
     
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController : WeatherManagerDelegate {
     func didUpdateWeather(_ weatherManager : WeatherManager, _ weather: WeatherModel) {
          DispatchQueue.main.async {
               self.temperatureLabel.text = weather.temperatureString
               self.conditionImageView.image = UIImage(systemName: weather.conditionName)
               self.cityLabel.text = weather.cityName
          }
          
     }
     
     func didFailWithError(_ error: Error) {
          print(error)
     }
}
 
//MARK: - CLLocationManagerDelegate

extension WeatherViewController : CLLocationManagerDelegate{
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          if let location = locations.last {
               locationManager.stopUpdatingLocation()
               let lat = location.coordinate.latitude
               let long = location.coordinate.longitude
               weatherManager.fetchWeather(latitude: lat, longitude: long)
               
          }
     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
          print(error)
     }
}

