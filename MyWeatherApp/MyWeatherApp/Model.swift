//
//  Model.swift
//  MyWeatherApp
//
//  Created by Appinventiv Mac on 21/03/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import Foundation

// MARK: MODEL for getting location cordinates


struct Places:Decodable{
    var results : [Results]
}

struct Results:Decodable {
    var geometry:Geometry
}

struct Geometry:Decodable {
    var location:Location
}

struct Location:Decodable {
    var lat:Float
    var lng:Float
}

// MARK: MODEL for getting weather and temperature details

struct Weather : Decodable {
    var currently : Currently
}

struct Currently : Decodable {
    
    var summary:String
    var precipProbability:Float
    var temperature:Float
    var apparentTemperature:Float
    var humidity:Float
    var windSpeed:Float
    var uvIndex:Float
    var icon:String
}
