//
//  DestinationView.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

protocol DestinationViewDelegate: class {
    func didCheckOrigin(airport: Airport)
    func didCheckDestination(airport: Airport)
    func didCheckAllOrigin(isChecked: Bool)
    func didCheckAllDestination(isChecked: Bool)
}

class DestinationView: UITableViewCell {
    var isOriginSelected = false
    var isDestinationSelected = false
    
    @IBOutlet weak var tableviewOrigin: UITableView!
    @IBOutlet weak var tableviewDestination: UITableView!
    
    @IBOutlet weak var constraintOrigin: NSLayoutConstraint!
    @IBOutlet weak var constraintDestination: NSLayoutConstraint!
    
    var airportOrigin: [Airport] = [Airport]()
    var airportDestination: [Airport] = [Airport]()
    
    var arrayCheckedOrigin = [Airport]()
    var arrayCheckedDestination = [Airport]()
    
    weak var delegate: DestinationViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableviewOrigin.delegate = self
        tableviewOrigin.dataSource = self
        
        tableviewDestination.delegate = self
        tableviewDestination.dataSource = self
        
        tableviewOrigin.register(UINib(nibName: "AirlinesCell", bundle:nil), forCellReuseIdentifier: "AirlinesCell")
        tableviewOrigin.separatorStyle = .none
        tableviewOrigin.isScrollEnabled = false
        
        tableviewDestination.register(UINib(nibName: "AirlinesCell", bundle:nil), forCellReuseIdentifier: "AirlinesCell")
        tableviewDestination.separatorStyle = .none
        tableviewDestination.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension DestinationView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // add +1 for check all
        if (tableView == tableviewOrigin) {
            return airportOrigin.count + 1
        }
        
        return airportDestination.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == tableviewOrigin) {
            return self .tableView(tableView, cellForRowAt: indexPath, arrayOptions: airportOrigin, arrayChecked: arrayCheckedOrigin)
        }
        
        return self.tableView(tableView, cellForRowAt: indexPath, arrayOptions: airportDestination, arrayChecked: arrayCheckedDestination)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, arrayOptions: [Airport], arrayChecked: [Airport]) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirlinesCell", for: indexPath) as! AirlinesCell
        
        // row check all
        if indexPath.row == 0 {
            if arrayChecked.count == arrayOptions.count {
                cell.btnCheck.image = UIImage(named: "check rect")
                cell.lbTitle.textColor = UIColor(hex: 0x674290)
            } else {
                cell.btnCheck.image = UIImage(named: "uncheck rect")
                cell.lbTitle.textColor = UIColor(hex: 0x515151)
            }
            
            cell.lbTitle.text = "All Airports"
        } else {
            let airport = arrayOptions[indexPath.row - 1]
            
            if (arrayChecked.contains(airport)) {
                cell.btnCheck.image = UIImage(named: "check rect")
                cell.lbTitle.textColor = UIColor(hex: 0x674290)
            } else {
                cell.btnCheck.image = UIImage(named: "uncheck rect")
                cell.lbTitle.textColor = UIColor(hex: 0x515151)
            }
            
            cell.lbTitle.text = airport.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == tableviewOrigin) {
            self.tableView(tableView: tableView, didDeselectRowAt: indexPath, arrayOptions: airportOrigin, arrayChecked: &arrayCheckedOrigin)
        } else {
            self.tableView(tableView: tableView, didDeselectRowAt: indexPath, arrayOptions: airportDestination, arrayChecked: &arrayCheckedDestination)
        }
        
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, didDeselectRowAt indexPath: IndexPath, arrayOptions: [Airport], arrayChecked: inout [Airport]) {
        if indexPath.row == 0 {
            // check all
            if arrayChecked.count == arrayOptions.count {
                // remove all
                arrayChecked.removeAll()
                
                if tableView == tableviewOrigin {
                    delegate?.didCheckAllOrigin(isChecked: false)
                } else {
                    delegate?.didCheckAllDestination(isChecked: false)
                }
            } else {
                // add all
                arrayChecked.removeAll()
                
                for airport in arrayOptions {
                    arrayChecked.append(airport)
                }
                
                if tableView == tableviewOrigin {
                    delegate?.didCheckAllOrigin(isChecked: true)
                } else {
                    delegate?.didCheckAllDestination(isChecked: true)
                }
            }
            
        } else {
            let airport = arrayOptions[indexPath.row - 1]
            
            if (arrayChecked.contains(airport)) {
                let index = arrayChecked.index(of: airport)
                arrayChecked.remove(at: index!)
            } else {
                arrayChecked.append(airport)
            }
            
            if tableView == tableviewOrigin {
                delegate?.didCheckOrigin(airport: airport)
            } else {
                delegate?.didCheckDestination(airport: airport)
            }
        }
    }
}
