//
//  SelectCurrencyVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/19/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class SelectCurrencyVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    let currencyList = [("US","USD"), ("Singapore", "SGP")]
    var selectedCurrency = "USD"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCurrency = ProfileVC.currentCurrencyType
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        var attributes = [NSForegroundColorAttributeName : UIColor(hex: 0x515151), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 15)!]
        
        if currencyList[indexPath.row].1 == selectedCurrency {
            attributes = [NSForegroundColorAttributeName : UIColor(hex: 0x674290), NSFontAttributeName: UIFont(name: GothamFontName.Bold.rawValue, size: 15)!]
        }
        
        cell.textLabel?.attributedText = NSAttributedString(string: currencyList[indexPath.row].0, attributes: attributes)
        
        cell.detailTextLabel?.attributedText = NSAttributedString(string: currencyList[indexPath.row].1, attributes:attributes)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCurrency = currencyList[indexPath.row].1
        ProfileVC.currentCurrencyType = selectedCurrency
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
