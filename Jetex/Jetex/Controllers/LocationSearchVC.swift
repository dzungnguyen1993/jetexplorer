//
//  LocationSearchVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/10/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

protocol PickLocationDelegate: class {
    func didPickLocation(airport: Airport, isLocationFrom: Bool)
}

class LocationSearchVC: BaseViewController {

    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    @IBOutlet weak var topNavigationItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    weak var delegate: PickLocationDelegate?
    
    var airportsSearchResult: Results<Airport>! = nil
    
    var isLocationFrom: Bool!
    var realm : Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        leftBarButton.width = -16
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "SearchCityCell", bundle:nil), forCellReuseIdentifier: "SearchCityCell")
        
        realm = try! Realm()
        tableView.separatorStyle = .none
    }
    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        let predicate = NSPredicate(format: "name BEGINSWITH[c] %@", sender.text!)
        
        airportsSearchResult = realm.objects(Airport.self).filter(predicate)
        
        tableView.separatorStyle = airportsSearchResult.count == 0 ? .none : .singleLine
        tableView.reloadData()
    }
    
    @IBAction func clearSearchField(_ sender: UIButton) {
        searchTextField.text = ""
        airportsSearchResult = nil
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
    
    @IBAction func searchCity(_ sender: UIButton) {
    }
}

extension LocationSearchVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard airportsSearchResult != nil else {
            return 0
        }
        return airportsSearchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCityCell", for: indexPath) as! SearchCityCell
        
        let airport = airportsSearchResult[indexPath.row]
        
        cell.lbCountry.text = self.getCountryName(fromAirport: airport)
        cell.lbAirport.text = airport.id
        
        
        let attributes = [NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 17)!]
        let attributedString = NSMutableAttributedString(string: airport.name, attributes: attributes)
        let prefixAttributes = [NSForegroundColorAttributeName: UIColor(hex: 0x674290),
                                NSFontAttributeName: UIFont(name: GothamFontName.Bold.rawValue, size: 17)!]
        attributedString.addAttributes(prefixAttributes, range: NSRange(location: 0, length: searchTextField.text!.characters.count))
        cell.lbCity.attributedText = attributedString
        
        return cell
    }
    
    func getCountryName(fromAirport airport: Airport) -> String {
        let cityId = airport.cityId
        var predicate = NSPredicate(format: "id == %@", cityId)
        let city = realm.objects(City.self).filter(predicate).first
        
        guard city != nil else {
            return ""
        }
        
        let countryId = airport.countryId
        predicate = NSPredicate(format: "id == %@", countryId)
        let country = realm.objects(Country.self).filter(predicate).first
        
        guard country != nil else {
            return ""
        }
        
        return (city?.name)! + ", " + (country?.name)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let airport = airportsSearchResult[indexPath.row]
        self.delegate?.didPickLocation(airport: airport, isLocationFrom: isLocationFrom)
        self.navigationController!.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
