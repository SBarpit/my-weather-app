//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Appinventiv Mac on 19/03/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
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
    @IBOutlet weak var displayLB: UILabel!
    @IBOutlet weak var show: UIButton!
    
    // MARK: Class Properties
    
    var tb:Weather!
    var toggle:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.shadowOffset = CGSize(width: 5, height: 5)
        mainView.layer.shadowOpacity = 0.3
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.isHidden = true
        displayLB.isHidden = true
        show.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Action method
    
    @IBAction func showData(_ sender: UIButton) {
        if toggle{
            if let image = UIImage(named:"on") {
                self.toggle = !self.toggle
                sender.setImage(image, for: .normal)
                self.collectionView.isHidden = true
                self.collectionView.reloadData()
            }
        }else{
            if let image = UIImage(named:"off") {
                self.toggle = !self.toggle
                sender.setImage(image, for: .normal)
                self.collectionView.isHidden = false
            }
        }
    }
}


// MARK: Request and callback

extension ViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let querry = self.searchBar.text
        let newString = querry?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        APIController().weather(newString!, fail: { (e) in
            print("Error : \(e)")
        }) { (currentData) in
            self.tb = currentData
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                let temp = (currentData.currently.temperature - 32) * 5/9
                print(temp)
                let y = Float(round(100*temp)/100)
                self.currentTempLB.text = "\(y)°C"
                self.rainLB.text = "Rain: \(currentData.currently.precipProbability)"
                self.humidLB.text = "Humid: \(currentData.currently.humidity)"
                self.visibilityLB.text = "Wind: \(currentData.currently.windSpeed) km/h"
                self.feelLB.text = "Feels: \(currentData.currently.apparentTemperature)°F"
                self.uvIndexLB.text = "UVIndex \(currentData.currently.uvIndex)"
                self.summaryLB.text = " \(currentData.currently.summary)"
                self.weatherImageView.image = UIImage(named:currentData.currently.icon )
                self.show.isHidden = false
                self.displayLB.isHidden = false
                self.collectionView.reloadData()
                
                if currentData.currently.icon == "clear-day" || currentData.currently.icon == "snow"{
                    self.weatherImageView.layer.removeAllAnimations()
                    self.rotationAnimation()
                }
                else if currentData.currently.icon == "fog" ||  currentData.currently.icon == "partly-cloudy-day" || currentData.currently.icon == "clear-night" {
                    self.weatherImageView.layer.removeAllAnimations()
                    self.zigzagAnimation()
                }
                
            })
            
        }
    }
    
}

// MARK: TAbleView datasouce and delegate methods

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tb == nil {
            return 0
        }else{
            return tb.hourly.data.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? MyCell
        let temp = (tb.hourly.data[indexPath.item].temperature - 32) * 5/9
        let y = Float(round(100*temp)/100)
        cell?.tempLB.text = "\(y)°C"
        cell?.cellImageView.image = UIImage(named: tb.hourly.data[indexPath.item].icon)
        print(tb.hourly.data[indexPath.item].icon)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.bounds.width
        return CGSize(width: w/3, height: collectionView.bounds.height)
    }
    
    
}

// MARK: Animations

extension ViewController{
    
    func rotationAnimation(){
        
        self.weatherImageView.startAnimating()
        UIView.animate(withDuration: 2.0, delay: 0.2, options: [.curveLinear,.repeat,.autoreverse], animations: {
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

