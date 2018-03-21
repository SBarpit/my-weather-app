//
//  Model.swift
//  MyWeatherApp
//
//  Created by Appinventiv Mac on 21/03/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import Foundation

// MARK: MODEL for getting location cordinates

struct Places:Decodable {
    var results:[Result]
}

struct Result:Decodable {
    var geometry:Geometry
}

struct Geometry:Decodable {
    var location:Location
}

struct Location:Decodable {
    var lat:Int
    var lng:Int
}

// MARK: MODEL for getting weather and temperature details

struct Currently : Decodable {
    
    var summary:String
    var icon:String
    var precipProbability:String
    var temperature:Int
    var apparentTemperature:Int
    var humidity:Int
    var windSpeed:Int
    var uvIndex:Int
    
}
