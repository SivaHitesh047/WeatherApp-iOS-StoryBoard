//
//  WeatherManager.swift
//  Clima
//
//  Created by Siva Hitesh Kasturi.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager, _ weather: WeatherModel)
    func didFailWithError(_ error : Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=8bcf8cc8944dd4885466aef65ff869f6&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName : String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString)
    }
    
    func fetchWeather(latitude : Double, longitude : Double){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString)
    }
    
    func performRequest(_ urlString : String){
        //1. Create a URL
        if let url = URL(string: urlString){
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error!)
                    return 
                }
                
                if let safeData = data {
                    if let weather = parseJSON(safeData){
                        delegate?.didUpdateWeather(self, weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
            
        } catch{
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
    
}
