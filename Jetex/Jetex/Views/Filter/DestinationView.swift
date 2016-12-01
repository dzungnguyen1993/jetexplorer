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
        if (tableView == tableviewOrigin) {
            return airportOrigin.count
        }
        
        return airportDestination.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == tableviewOrigin) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AirlinesCell", for: indexPath) as! AirlinesCell
            
            let airport = airportOrigin[indexPath.row]
            
            if (arrayCheckedOrigin.contains(airport)) {
                cell.btnCheck.image = UIImage(named: "check rect")
                cell.lbTitle.textColor = UIColor(hex: 0x674290)
            } else {
                cell.btnCheck.image = UIImage(named: "uncheck rect")
                cell.lbTitle.textColor = UIColor(hex: 0x515151)
            }
            
            cell.lbTitle.text = airportOrigin[indexPath.row].name
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirlinesCell", for: indexPath) as! AirlinesCell
        
        let airport = airportDestination[indexPath.row]
        if (arrayCheckedDestination.contains(airport)) {
            cell.btnCheck.image = UIImage(named: "check rect")
            cell.lbTitle.textColor = UIColor(hex: 0x674290)
        } else {
            cell.btnCheck.image = UIImage(named: "uncheck rect")
            cell.lbTitle.textColor = UIColor(hex: 0x515151)
        }
        
        cell.lbTitle.text = airportDestination[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == tableviewOrigin) {
            let airport = airportOrigin[indexPath.row]
            
            if (arrayCheckedOrigin.contains(airport)) {
                let index = arrayCheckedOrigin.index(of: airport)
                arrayCheckedOrigin.remove(at: index!)
            } else {
                arrayCheckedOrigin.append(airport)
            }
            
            delegate?.didCheckOrigin(airport: airport)
        } else {
            let airport = airportDestination[indexPath.row]
            
            if (arrayCheckedDestination.contains(airport)) {
                let index = arrayCheckedDestination.index(of: airport)
                arrayCheckedDestination.remove(at: index!)
            } else {
                arrayCheckedDestination.append(airport)
            }
            
            delegate?.didCheckDestination(airport: airport)
        }
        
        tableView.reloadData()
    }

}
