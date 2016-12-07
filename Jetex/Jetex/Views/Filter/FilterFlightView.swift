//
//  FilterFlightView.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

protocol FilterFlightViewDelegate: class {
    func hideFilter()
    func applyFilter(filterObject: FilterObject)
}

class FilterFlightView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FilterFlightViewDelegate?
    var stopViewHeight = 180 + 12 // + 12 for bottom padding
    var airlinesViewHeight = 104
    var destinationViewHeight = 94
    var applyViewHeight = 76
    @IBOutlet weak var imgCancel: UIImageView!
    var searchResult: SearchFlightResult! = nil
    var isShowAllAirlines: Bool = false
    
    var arrayCheckCarrier: [Int] = [Int]()
    var checkStop: StopCheckType = .any
    
    //
    var filterObject: FilterObject = FilterObject()
    var tmpFilterObject: FilterObject = FilterObject()
    
    var origin: Airport! = Airport()
    var destination: Airport! = Airport()
    var arrayOrigin: [Airport] = [Airport]()
    var arrayDestination: [Airport] = [Airport]()
    var arrayCheckOrigin: [Airport] = [Airport]()
    var arrayCheckDestination: [Airport] = [Airport]()
    
    // MARK: Initialization
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        Bundle.main.loadNibNamed("FilterFlightView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("FilterFlightView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "StopView", bundle:nil), forCellReuseIdentifier: "StopView")
        tableView.register(UINib(nibName: "AirlinesView", bundle:nil), forCellReuseIdentifier: "AirlinesView")
        tableView.register(UINib(nibName: "DestinationView", bundle:nil), forCellReuseIdentifier: "DestinationView")
        tableView.register(UINib(nibName: "ApplyFilterView", bundle:nil), forCellReuseIdentifier: "ApplyFilterView")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        imgCancel.image = UIImage(fromHex: JetExFontHexCode.jetexCross.rawValue, withColor: UIColor(hex: 0x515151))
    }
    
    @IBAction func hideFilter(_ sender: UIButton) {
        delegate?.hideFilter()
    }
    
    func setFilterInfo(searchResult: SearchFlightResult, origin: Airport, destination: Airport) {
        self.searchResult = searchResult
        self.origin = origin
        self.destination = destination
        
        let cityOrigin = DBManager.shared.getCity(withIataCode: origin.id)
        
        if (cityOrigin != nil && (cityOrigin?.airports.count)! > 0) {
            arrayOrigin = DBManager.shared.convertListAirportToArray(list: (cityOrigin?.airports)!)
        } else {
            arrayOrigin = [origin]
        }
        
        let cityDestination = DBManager.shared.getCity(withIataCode: destination.id)
        
        if (cityDestination != nil && (cityDestination?.airports.count)! > 0) {
            arrayDestination = DBManager.shared.convertListAirportToArray(list: (cityDestination?.airports)!)
        } else {
            arrayDestination = [destination]
        }
        
        for i in 0..<searchResult.carriers.count {
            self.filterObject.checkedCarriers.append(i)
        }
        
        for airport in arrayOrigin {
            self.filterObject.checkedOrigin.append(airport)
        }
        
        for airport in arrayDestination {
            self.filterObject.checkedDestination.append(airport)
        }
        
        self.tableView.reloadData()
    }
}

extension FilterFlightView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StopView", for: indexPath) as! StopView
            cell.checkedIndex = filterObject.stopType.rawValue
            cell.tableView.reloadData()
            cell.delegate = self
            return cell
        }
        
        if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AirlinesView", for: indexPath) as! AirlinesView
            cell.arrayChecked = filterObject.checkedCarriers
            
            if (searchResult != nil) {
                cell.carriers = searchResult.carriers
                
                if (searchResult.carriers.count <= 4) {
                    // hide button show all
                    cell.constraintBtnShowAllHeight.constant = 0
                    cell.constraintTableHeight.constant = CGFloat(searchResult.carriers.count * 44)
                    cell.btnShowAll.isHidden = true
                } else {
                    if (isShowAllAirlines) {
                        cell.btnShowAll.setTitle("Hide", for: .normal)
                    } else {
                        cell.btnShowAll.setTitle("Show all " + (cell.carriers?.count.toString())! + " Airlines", for: .normal)
                    }
                }
            }
            
            cell.tableView.reloadData()
            cell.delegate = self
            return cell
        }
        
        if (indexPath.row == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationView", for: indexPath) as! DestinationView
            cell.arrayCheckedOrigin = filterObject.checkedOrigin
            cell.arrayCheckedDestination = filterObject.checkedDestination
            
            cell.airportOrigin = self.arrayOrigin
            cell.airportDestination = self.arrayDestination
            
            cell.constraintOrigin.constant = CGFloat(44 * cell.airportOrigin.count)
            cell.constraintDestination.constant = CGFloat(44 * cell.airportDestination.count)
            
            cell.tableviewOrigin.reloadData()
            cell.tableviewDestination.reloadData()
            cell.delegate = self
            
            return cell
        }
        
        if (indexPath.row == 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyFilterView", for: indexPath) as! ApplyFilterView
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row) {
        case 0: return CGFloat(stopViewHeight)
        case 1 :
            guard searchResult != nil else {
                return CGFloat(airlinesViewHeight)
            }
            
            if (searchResult.carriers.count <= 4) {
                // hide button show all
                return CGFloat(airlinesViewHeight + 44 * searchResult.carriers.count) - 30
            }
            
            if (isShowAllAirlines == false) {
                return CGFloat(airlinesViewHeight) + CGFloat(44) * CGFloat(min(searchResult.carriers.count, 4))
            }
            return CGFloat(airlinesViewHeight + 44 * searchResult.carriers.count)
        case 2:
            return CGFloat(destinationViewHeight + 44 * (arrayOrigin.count + arrayDestination.count))
        default: return CGFloat(applyViewHeight)
        }
    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.01
//    }
    
}

extension FilterFlightView: AirlinesViewDelegate {
    func showAllAirlines() {
        isShowAllAirlines = true
        self.tableView.reloadData()
    }
    
    func hideAirlines() {
        isShowAllAirlines = false
        self.tableView.reloadData()
    }
    
    func didCheck(index: Int) {
        if (self.tmpFilterObject.checkedCarriers.contains(index)) {
            let index = self.tmpFilterObject.checkedCarriers.index(of: index)
            self.tmpFilterObject.checkedCarriers.remove(at: index!)
        } else {
            self.tmpFilterObject.checkedCarriers.append(index)
        }
    }
}

extension FilterFlightView: StopViewDelegate {
    func didChooseStopType(type: StopCheckType) {
        tmpFilterObject.stopType = type
    }
}

extension FilterFlightView: DestinationViewDelegate {
    func didCheckOrigin(airport: Airport) {
        if (self.tmpFilterObject.checkedOrigin.contains(airport)) {
            let index = self.tmpFilterObject.checkedOrigin.index(of: airport)
            self.tmpFilterObject.checkedOrigin.remove(at: index!)
        } else {
            self.tmpFilterObject.checkedOrigin.append(airport)
        }
    }
    
    func didCheckDestination(airport: Airport) {
        if (self.tmpFilterObject.checkedOrigin.contains(airport)) {
            let index = self.tmpFilterObject.checkedDestination.index(of: airport)
            self.tmpFilterObject.checkedDestination.remove(at: index!)
        } else {
            self.tmpFilterObject.checkedDestination.append(airport)
        }
    }
}

extension FilterFlightView: ApplyFilterViewDelegate {
    func clickApply() {
        applyFilter()
        delegate?.hideFilter()
    }
    
    func applyFilter() {
        filterObject = tmpFilterObject.copyFilter()
        
        self.delegate?.applyFilter(filterObject: filterObject)
    }
}
