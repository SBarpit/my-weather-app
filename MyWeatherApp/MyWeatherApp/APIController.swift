//
//  APIController.swift
//  MyWeatherApp
//
//  Created by Appinventiv Mac on 21/03/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//
// API weather key : "your key"
//
// API weather : https://api.darksky.net/forecast/-----key-----/37.8267,-122.4233
//
// API Google Places key: "your key"
//
// API google Places : https://maps.googleapis.com/maps/api/place/textsearch/xml?query=query&key=---YOUR_API_KEY---

import Foundation






class APIController  {
    
    var places:Places!
    var location:Weather!
    var lat,lng:String?
    
    
    //MARK: GOOGLE places code
    
    func googlePlaces(_ location:String,success: @escaping (Places) -> Void,fail: @escaping (Error) -> Void){
        
        let request = getGoogleRequest(location)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                print(error as Any)
                fail(error!)
            }else{
                do {
                    let s = String(data: data!, encoding: String.Encoding.ascii)
                    print(s)
                    self.places = try JSONDecoder().decode(Places.self, from: data!)
                    if self.places.status == "ZERO_RESULTS" {
                        DispatchQueue.main.async {
                             Alerts.displayAlertMessage(messageToDisplay: "Please check the location !")
                        }
                    }
                        else if self.places.status == "INVALID_REQUEST"{
                        DispatchQueue.main.async {
                            Alerts.displayAlertMessage(messageToDisplay: "Invalid place !")
                        }
                    }else{
                    success(self.places)
                    }
                }
                catch {
                    print("Error")
                }
                
            }
            
        }).resume()
    }
    
    // MARK: Send request to server
    
    func getGoogleRequest(_ search:String) -> NSMutableURLRequest{
        return NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(search)&key=AIzaSyBatToiKxdUkBLl_pB-COLqUUeEH3UljoY")! as URL,
                                   cachePolicy: .useProtocolCachePolicy,
                                   timeoutInterval: 10.0)
    }
    
    
    // MARK : Weather Forcast Code
    
    
    func weather(_ location:String,fail: @escaping (String) -> Void, success: @escaping (Weather) -> Void){
        
        self.googlePlaces(location, success: { (places) in
            self.lat = "\(places.results[0].geometry.location.lat)"
            self.lng = "\(places.results[0].geometry.location.lng)"
            print(self.lat!)
            print(self.lng!)
            let url = "https://api.darksky.net/forecast/7e6c32b2c611bee975108ca85e874d6b/\(self.lat!),\(self.lng!)"
            let bsaeURL = URL(string: url)
            URLSession.shared.dataTask(with: bsaeURL!, completionHandler: {(data, response, error) -> Void in
                
                if (error != nil) {
                    fail("Error in Weather fetching")
                }else{
                    guard let  data = data else { return }
//                    let s:String = String(data: data, encoding: String.Encoding.ascii)!
//                    print(s)
                    do {
                        self.location = try JSONDecoder().decode(Weather.self, from: data)
                        success(self.location)
                    }
                    catch {
                        print("Error")
                    }
                }
            }).resume()
            
            
        }) { (error) in
            fail("Error in Location fetching")
        }
        
    }
    
}








