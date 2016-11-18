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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        cell.textLabel?.attributedText = NSAttributedString(string: currencyList[indexPath.row].0, attributes: [NSForegroundColorAttributeName : UIColor(hex: 0x515151), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 15)!])
        
        cell.detailTextLabel?.attributedText = NSAttributedString(string: currencyList[indexPath.row].1, attributes: [NSForegroundColorAttributeName : UIColor(hex: 0x515151), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 15)!])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
