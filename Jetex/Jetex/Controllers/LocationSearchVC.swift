//
//  LocationSearchVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/10/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class LocationSearchVC: BaseViewController {

    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    @IBOutlet weak var topNavigationItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var citiesSearchResult: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        leftBarButton.width = -16
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "SearchCityCell", bundle:nil), forCellReuseIdentifier: "SearchCityCell")
    }
}

extension LocationSearchVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return citiesSearchResult.count
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCityCell", for: indexPath) as! SearchCityCell
        
        cell.lbCity.text = "Tan Son Nhat Airport"
        cell.lbCountry.text = "Ho Chi Minh, Vietnam"
        cell.lbAirport.text = "SGN"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
