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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailForecastCell") as! DetailForecastCell
        return cell
    }

    @IBAction func dismissVC(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

}
