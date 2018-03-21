//
//  APIController.swift
//  MyWeatherApp
//
//  Created by Appinventiv Mac on 21/03/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//
// API weather key : 7e6c32b2c611bee975108ca85e874d6b
//
// API weather : https://api.darksky.net/forecast/7e6c32b2c611bee975108ca85e874d6b/37.8267,-122.4233
//
// API Google Places key: AIzaSyAy2f0C6WFb9xOyuh00t0pVqdjbGdcosWk
//
// API google Places : https://maps.googleapis.com/maps/api/place/textsearch/xml?query=\(query)&key=YOUR_API_KEY

import Foundation






class APIController  {
    
    var places:Places!
    var location:Currently!
    var lat,lng:Double!
    
    
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
                    self.places =  try JSONDecoder().decode(Places.self, from: data!)
                    success(self.places)
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
    
    
    func weather(_ location:String,fail: @escaping (String) -> Void, success: @escaping (Currently) -> Void){
        
        self.googlePlaces(location, success: { (places) in
            for i in places.results{
                self.lat = Double(i.geometry.location.lat)
                self.lng = Double(i.geometry.location.lng)
            }
        }) { (error) in
            print("Error")
        }
        let url = "https://api.darksky.net/forecast/7e6c32b2c611bee975108ca85e874d6b/\(self.lat),\(self.lng)"
        let bsaeURL = URL(string: url)
        URLSession.shared.dataTask(with: bsaeURL!, completionHandler: {(data, response, error) -> Void in
            
            if (error != nil) {
                fail("Error in Weather fetching")
            }else{
                do {
                    self.location =  try JSONDecoder().decode(Currently.self, from: data!)
                    success(self.location)
                }
                catch {
                    print("Error")
                }
            }
        }).resume()
    }
   
    }
    
    


    
   
    

