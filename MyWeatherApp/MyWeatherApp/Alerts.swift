//
//  Alerts.swift
//  MyWeatherApp
//
//  Created by Appinventiv Mac on 23/03/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import Foundation

import UIKit

class Alerts {
    
    static func displayAlertMessage(messageToDisplay: String)
    {
        let alertController = UIAlertController(title: "Alert!", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Ok button of Alert tapped") }
        
        alertController.addAction(OKAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
