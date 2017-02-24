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
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchingIndicator: UIActivityIndicatorView!
    weak var delegate: PickLocationDelegate?
    weak var currentAirPort: Airport?
    
    var airportsSearchResult: [Airport] = [Airport]()
    
    var isLocationFrom: Bool!
    var realm : Realm!
    var allAirports: Results<Airport>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        leftBarButton.width = -16
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "SearchCityCell", bundle:nil), forCellReuseIdentifier: "SearchCityCell")
        
        tableView.separatorStyle = .none
        
        if (isLocationFrom == true) {
            topNavigationItem.title = "Flight From"
        } else {
            topNavigationItem.title = "Flight To"
        }
        
        // update current airport to UI
        if let currentAirPort = currentAirPort {
            searchTextField.text = currentAirPort.name
        }
     
        realm = try! Realm()
        self.allAirports = realm.objects(Airport.self)
        hideIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchTextField.resignFirstResponder()
    }
    
    func showIndicator() {
        searchingIndicator.startAnimating()
        searchButton.isHidden = true
    }
    
    func hideIndicator() {
        searchingIndicator.stopAnimating()
        searchButton.isHidden = false
    }
    
    func searchForResult(_ text: String) {
        self.airportsSearchResult = allAirports.filter { (airport) -> Bool in
            
            let name = airport.name
            
            let id = airport.id
            
            if ((text.characters.count) <= name.characters.count) {
                let startIndex = name.startIndex
                let endIndex = name.index(startIndex, offsetBy: (text.characters.count))
                
                let substr = name.substring(to: endIndex)
                
                if (substr.lowercased() == text.lowercased()) {
                    return true
                }
            }
            
            if ((text.characters.count) <= id.characters.count) {
                if (id.lowercased().contains(text.lowercased())) {
                    return true
                }
            }
            
            return false
        }
        
        tableView.separatorStyle = airportsSearchResult.count == 0 ? .none : .singleLine
        tableView.reloadData()
        hideIndicator()
    }


    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        // cancel previous request
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        if sender.text == "" {
            airportsSearchResult.removeAll()
            tableView.separatorStyle = .none
            tableView.reloadData()
            hideIndicator()
        } else {
            self.perform(#selector(LocationSearchVC.searchForResult(_:)), with: sender.text!, afterDelay: 1)
            showIndicator()
        }
    }
    
    @IBAction func searchCity(_ sender: UIButton) {
    }
}

extension LocationSearchVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airportsSearchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCityCell", for: indexPath) as! SearchCityCell
        
        let airport = airportsSearchResult[indexPath.row]
    
        cell.lbCountry.text = self.getCountryName(fromAirport: airport)
    
        // text for airport name
        if (airport.name.lowercased().isContainsAtBeginning(of: searchTextField.text!.lowercased()) == true) {
            let attributes = [NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 17)!]
            let attributedString = NSMutableAttributedString(string: airport.name, attributes: attributes)
            let prefixAttributes = [NSForegroundColorAttributeName: UIColor(hex: 0x674290),
                                    NSFontAttributeName: UIFont(name: GothamFontName.Bold.rawValue, size: 17)!]
            attributedString.addAttributes(prefixAttributes, range: NSRange(location: 0, length: searchTextField.text!.characters.count))
            cell.lbCity.attributedText = attributedString
        } else {
            cell.lbCity.text = airport.name
        }
        
        // text for airport code
        let start = airport.id.lowercased().index(of: (searchTextField.text)!)
        if (start != -1) {
            let attributes = [NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 15)!]
            let attributedString = NSMutableAttributedString(string: airport.id, attributes: attributes)
            let prefixAttributes = [NSForegroundColorAttributeName: UIColor(hex: 0x674290),
                                NSFontAttributeName: UIFont(name: GothamFontName.Bold.rawValue, size: 15)!]
            attributedString.addAttributes(prefixAttributes, range: NSRange(location: start, length: searchTextField.text!.characters.count))
            
            cell.lbAirport.attributedText = attributedString
        } else {
            cell.lbAirport.text = airport.id
        }
        
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
    }
}
