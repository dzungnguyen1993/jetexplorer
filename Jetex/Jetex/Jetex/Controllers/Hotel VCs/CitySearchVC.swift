//
//  LocationSearchVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/10/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

protocol PickCityDelegate: class {
    func didPickLocation(city: City)
}

class CitySearchVC: BaseViewController {

    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var topNavigationItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchingIndicator: UIActivityIndicatorView!
    
    weak var delegate: PickCityDelegate?
    weak var currentCity: City?
    
    var citiesSearchResult: [City] = [City]()
    
    var realm : Realm!
    var allCities: Results<City>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        leftBarButton.width = -16
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "SearchCityCell", bundle:nil), forCellReuseIdentifier: "SearchCityCell")
        
        tableView.separatorStyle = .none
        
        topNavigationItem.title = "Where"
        
        // update current airport to UI
        if let currentCity = currentCity {
            searchTextField.text = currentCity.name
        }
     
        realm = try! Realm()
        self.allCities = realm.objects(City.self)
        
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
        self.citiesSearchResult = allCities.filter { (city) -> Bool in
            
            let name = city.name
            
            if ((text.characters.count) <= name.characters.count) {
                let startIndex = name.startIndex
                let endIndex = name.index(startIndex, offsetBy: (text.characters.count))
                
                let substr = name.substring(to: endIndex)
                
                if (substr.lowercased() == text.lowercased()) {
                    return true
                }
            }
            
            return false
        }
        tableView.separatorStyle = citiesSearchResult.count == 0 ? .none : .singleLine
        tableView.reloadData()
        hideIndicator()
    }
    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        // cancel previous request
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        if sender.text == "" {
            citiesSearchResult.removeAll()
            tableView.separatorStyle = .none
            tableView.reloadData()
            hideIndicator()
        } else {
            // create new request
            self.perform(#selector(CitySearchVC.searchForResult(_:)), with: sender.text!, afterDelay: 1)
            showIndicator()
        }
        
    }
    
    @IBAction func searchCity(_ sender: UIButton) {
    }
}

extension CitySearchVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesSearchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCityCell", for: indexPath) as! SearchCityCell
        
        let city = citiesSearchResult[indexPath.row]
    
        let country = DBManager.shared.getCountry(fromCity: city)
        if (country != nil) {
            cell.lbCountry.text = country?.name
        } else {
            cell.lbCountry.text = ""
        }
    
        // text for airport name
        if (city.name.lowercased().isContainsAtBeginning(of: searchTextField.text!.lowercased()) == true) {
            let attributes = [NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 17)!]
            let attributedString = NSMutableAttributedString(string: city.name, attributes: attributes)
            let prefixAttributes = [NSForegroundColorAttributeName: UIColor(hex: 0x674290),
                                    NSFontAttributeName: UIFont(name: GothamFontName.Bold.rawValue, size: 17)!]
            attributedString.addAttributes(prefixAttributes, range: NSRange(location: 0, length: searchTextField.text!.characters.count))
            cell.lbCity.attributedText = attributedString
        } else {
            cell.lbCity.text = city.name
        }
        cell.lbAirport.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = citiesSearchResult[indexPath.row]
        self.delegate?.didPickLocation(city: city)
        self.navigationController!.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
    }
}
