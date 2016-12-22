//
//  SelectCabinClassVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 12/21/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class SelectCabinClassVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cabinClassList     = [("Economy", "Economy"),
                              ("Premium Economy", "PremiumEconomy"),
                              ("Business","Business"),
                              ("First Class", "First") ]
    
    var selectedcabinClass = "Economy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //selectedcabinClass = ProfileVC.currentcabinClassType
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cabinClassList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        var attributes = [NSForegroundColorAttributeName : UIColor(hex: 0x515151), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 15)!]
        
        if cabinClassList[indexPath.row].1 == selectedcabinClass {
            attributes = [NSForegroundColorAttributeName : UIColor(hex: 0x674290), NSFontAttributeName: UIFont(name: GothamFontName.Bold.rawValue, size: 15)!]
        }
        
        cell.textLabel?.attributedText = NSAttributedString(string: cabinClassList[indexPath.row].0, attributes: attributes)
        
        cell.detailTextLabel?.attributedText = NSAttributedString(string: cabinClassList[indexPath.row].1, attributes:attributes)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedcabinClass = cabinClassList[indexPath.row].1
        
        // TODO: update it back to searching view here
        
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
