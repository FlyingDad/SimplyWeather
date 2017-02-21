//
//  DetailForecastVC.swift
//  SimplyWeather
//
//  Created by Michael Kroth on 2/19/17.
//  Copyright © 2017 MGK Technology Solutions, LLC. All rights reserved.
//

import UIKit

class DetailForecastVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var forecastArray = [[String: AnyObject]]()
    let client = OpenWxClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            updateForeCastTable()
        }
        
        client.getDetailedForecast{ (success, error) in
            if success {
                self.updateForeCastTable()
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailForecastCell") as! DetailForecastCell
        let forecast = forecastArray[indexPath.row]
        cell.hour.text = forecast["hour"] as! String?
        cell.temp.text = forecast["temp"] as! String?
        cell.forecastLabel.text = forecast["condition"] as! String?
        cell.iconImage.image = UIImage(named: (forecast["icon"] as! String?)!)
        return cell
    }
    
    func updateForeCastTable() {
        forecastArray = UserDefaults.standard.array(forKey: "detailedForecastArray") as! [[String : AnyObject]]
        tableView.reloadData()
    }

    @IBAction func dismissVC(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

}
