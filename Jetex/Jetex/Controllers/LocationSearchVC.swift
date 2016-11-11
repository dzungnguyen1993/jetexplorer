//
//  LocationSearchVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/10/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

protocol PickLocationDelegate: class {
    func didPickLocation(city: City, isLocationFrom: Bool)
}

class LocationSearchVC: BaseViewController {

    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    @IBOutlet weak var topNavigationItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    weak var delegate: PickLocationDelegate?
    
    var citiesSearchResult: [City] = []
    var cities: [City] = []
    var isLocationFrom: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        leftBarButton.width = -16
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "SearchCityCell", bundle:nil), forCellReuseIdentifier: "SearchCityCell")
        
        self.initSearch()
        tableView.separatorStyle = .none
    }
    
    func initSearch() {
        let city1 = City(cityName: "Tan Son Nhat Airport", countryName: "Ho Chi Minh, Vietnam", countryID: "SGN")
        
        let city2 = City(cityName: "Tan Tan", countryName: "Morocco", countryID: "TTA")
        
        cities.append(city1)
        cities.append(city2)
    }
    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        citiesSearchResult.removeAll()
        guard let cityName = sender.text else {return}
        guard cityName.characters.count > 0 else {
            tableView.reloadData()
            return
        }
        
        citiesSearchResult += cities
        citiesSearchResult = citiesSearchResult.filter { (city) -> Bool in
            guard sender.text!.characters.count <= city.cityName.characters.count else {
                return false
            }
            let index = city.cityName.index(city.cityName.startIndex, offsetBy: sender.text!.characters.count)
            let prefixCityName = city.cityName.substring(to: index)
            return prefixCityName.lowercased() == cityName.lowercased()
        }
        
        tableView.separatorStyle = citiesSearchResult.count == 0 ? .none : .singleLine
        tableView.reloadData()
    }
    
    @IBAction func clearSearchField(_ sender: UIButton) {
        searchTextField.text = ""
        citiesSearchResult.removeAll()
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
    
    
    @IBAction func searchCity(_ sender: UIButton) {
    }
}

extension LocationSearchVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesSearchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCityCell", for: indexPath) as! SearchCityCell
        
        let city = citiesSearchResult[indexPath.row]
        
        cell.lbCountry.text = city.countryName
        cell.lbAirport.text = city.countryID
        
        let attributes = [NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 17)!]
        let attributedString = NSMutableAttributedString(string: citiesSearchResult[indexPath.row].cityName, attributes: attributes)
        let prefixAttributes = [NSForegroundColorAttributeName: UIColor(hex: 0x674290),
                                NSFontAttributeName: UIFont(name: GothamFontName.Bold.rawValue, size: 17)!]
        attributedString.addAttributes(prefixAttributes, range: NSRange(location: 0, length: searchTextField.text!.characters.count))
        cell.lbCity.attributedText = attributedString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = citiesSearchResult[indexPath.row]
        self.delegate?.didPickLocation(city: city, isLocationFrom: isLocationFrom)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
