//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Appinventiv Mac on 19/03/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var currentTempLB: UILabel!
    @IBOutlet weak var rainLB: UILabel!
    @IBOutlet weak var humidLB: UILabel!
    @IBOutlet weak var visibilityLB: UILabel!
    @IBOutlet weak var feelLB: UILabel!
    @IBOutlet weak var uvIndexLB: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var summaryLB: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var temp:Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.shadowOffset = CGSize(width: 5, height: 5)
        mainView.layer.shadowOpacity = 0.3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension ViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let querry = self.searchBar.text
        let newString = querry?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        APIController().weather(newString!, fail: { (e) in
            print("Error : \(e)")
        }) { (currentData) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.temp = (currentData.currently.temperature - 32) * 5/9
                print(self.temp)
                let y = Float(round(100*self.temp)/100)
                self.currentTempLB.text = "\(y)°C"
                self.rainLB.text = "Rain: \(currentData.currently.precipProbability)"
                self.humidLB.text = "Humid: \(currentData.currently.humidity)"
                self.visibilityLB.text = "Wind: \(currentData.currently.windSpeed) km/h"
                self.feelLB.text = "Feels: \(currentData.currently.apparentTemperature)°F"
            //    self.uvIndexLB.text = "UVIndex \(currentData.currently.uvIndex)"
                self.summaryLB.text = " \(currentData.currently.summary)"
                self.weatherImageView.image = UIImage(named:currentData.currently.icon )
                
                if currentData.currently.icon == "clear-day" || currentData.currently.icon == "snow"{
                    self.weatherImageView.layer.removeAllAnimations()
                    self.coverimageAnimation()
                }
                else if currentData.currently.icon == "fog" ||  currentData.currently.icon == "partly-cloudy-day" {
                    self.weatherImageView.layer.removeAllAnimations()
                    self.zigzagAnimation()
                }
                
            })
           
        }
    }
    
}


extension ViewController{
    
    func coverimageAnimation(){
        self.weatherImageView.startAnimating()
        UIView.animate(withDuration: 2.0, delay: 0.2, options: [.curveEaseInOut,.repeat,.autoreverse], animations: {
            self.weatherImageView.transform = CGAffineTransform(scaleX: 2, y: 0)
            self.weatherImageView.transform = CGAffineTransform(translationX: -5, y: 0)
            self.weatherImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            
        }) { (false) in
           
        }
        
    }
    func zigzagAnimation(){
        self.weatherImageView.startAnimating()
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [.curveEaseIn, .repeat, .autoreverse], animations: {
            self.weatherImageView.frame.origin.x = -5
        }) { (false) in
           
        }
    }
}

