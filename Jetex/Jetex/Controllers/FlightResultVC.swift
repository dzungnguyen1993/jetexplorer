//
//  FlightResultVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/15/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class FlightResultVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewOptions: UIView!
    @IBOutlet weak var viewFilterContainer: UIView!
    @IBOutlet weak var viewError: UIView!
    
    var viewFilter: FilterFlightView!
    
    var arrayResult: [FlightInfo]!
    
    var showDetailsIndex: Int = -1
    var detailsCellHeight: Int = 50
    var cellDefaultHeight: Int = 118
    var cellDefaultHeaderHeight: Int = 90
    
    @IBOutlet weak var btnCheapest: UIButton!
    @IBOutlet weak var viewUnderCheapest: UIView!
    
    @IBOutlet weak var btnFastest: UIButton!
    @IBOutlet weak var viewUnderFastest: UIView!
    
    @IBOutlet weak var imgFilter: UIImageView!
    @IBOutlet weak var imgPassenger: UIImageView!
    @IBOutlet weak var imgRightArrow: UIImageView!
    var passengerInfo: PassengerInfo! = PassengerInfo()
    
    @IBOutlet weak var lbOrigin: UILabel!
    @IBOutlet weak var lbDestination: UILabel!
    @IBOutlet weak var viewDateDepart: SearchResultDateView!
    @IBOutlet weak var viewDateReturn: SearchResultDateView!
    @IBOutlet weak var lbNumberPassenger: GothamBold17Label!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: "FlightResultCell", bundle: nil), forCellReuseIdentifier: "FlightResultCell")
        
        self.tableView.separatorStyle = .none
        
        initMockData()
        
        viewOptions.layer.borderWidth = 1.0
        viewOptions.layer.borderColor = UIColor(hex: 0xD6D6D6).cgColor
        
        setupImages()
        
        // show header info
        showHeaderInfo()
        
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
    }

    func showHeaderInfo() {
        lbOrigin.text = passengerInfo.airportFrom?.id
        lbDestination.text = passengerInfo.airportTo?.id
        lbNumberPassenger.text = String(passengerInfo.numberOfPassenger())
        viewDateDepart.lbDate.text = passengerInfo.departDay?.toDay()
        viewDateDepart.lbMonth.text = passengerInfo.departDay?.toMonth()
        viewDateReturn.lbDate.text = passengerInfo.returnDay?.toDay()
        viewDateReturn.lbMonth.text = passengerInfo.returnDay?.toMonth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (viewFilter == nil) {
            // add view filter
            viewFilter = FilterFlightView(frame: CGRect(x: 0, y: 0, width: viewFilterContainer.frame.size.width, height: viewFilterContainer.frame.size.height))
            viewFilterContainer.addSubview(viewFilter)
            viewFilter.delegate = self
        }
    }
    
    func initMockData() {
        let flightInfo = FlightInfo()
        
        self.arrayResult = [FlightInfo]()
        self.arrayResult.append(flightInfo)
        self.arrayResult.append(flightInfo)
        self.arrayResult.append(flightInfo)
        self.arrayResult.append(flightInfo)
        self.arrayResult.append(flightInfo)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func showCheapestTrip(_ sender: UIButton) {
        btnCheapest.alpha = 1.0
        viewUnderCheapest.isHidden = false
        
        btnFastest.alpha = 0.6
        viewUnderFastest.isHidden = true
        // do something
    }
    
    @IBAction func showFastestTrip(_ sender: UIButton) {
        btnCheapest.alpha = 0.6
        viewUnderCheapest.isHidden = true
        
        btnFastest.alpha = 1.0
        viewUnderFastest.isHidden = false
        // do something
    }
    
    @IBAction func showFilter(_ sender: UIButton) {
        viewFilterContainer.isHidden = false
        viewOptions.isHidden = true
        tableView.isHidden = true
    }
}

extension FlightResultVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // remember indexpath.section instead of indexpath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightResultCell", for: indexPath) as! FlightResultCell
        
        if (indexPath.section == showDetailsIndex) {
            cell.viewInfoGeneral.isHidden = true
            cell.viewDetails.isHidden = false
            
            cell.addViewDetails(flightInfo: arrayResult[indexPath.section])
            
            // set border
            cell.layer.borderColor = UIColor(hex: 0x674290).cgColor
            cell.layer.borderWidth = 1.0
        } else {
            cell.viewInfoGeneral.isHidden = false
            cell.viewDetails.isHidden = true
            
            // set border
            cell.layer.borderColor = UIColor(hex: 0xD6D6D6).cgColor
            cell.layer.borderWidth = 1.0
        }
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == showDetailsIndex) {
            return CGFloat(56 + 8 + FlightCellUtils.heightForDetailsOfFlightInfo(flightInfo: arrayResult[indexPath.section]))
        }
        return CGFloat(cellDefaultHeight)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayResult.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        if (section == 0) {
            view.backgroundColor = UIColor.white
        } else {
            view.backgroundColor = UIColor(hex: 0xF6F6F6)
        }
//        self.tableView.tableHeaderView = view;
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (showDetailsIndex != indexPath.section) {
            showDetailsIndex = indexPath.section
        } else {
            showDetailsIndex = -1
        }
        
        tableView.reloadData()
    }
    
}

extension FlightResultVC: FilterFlightViewDelegate {
    func hideFilter() {
        viewFilterContainer.isHidden = true
        viewOptions.isHidden = false
        tableView.isHidden = false
    }
}

extension FlightResultVC {
    func setupImages() {
        imgFilter.image = UIImage(fromHex: JetExFontHexCode.jetexSliders.rawValue, withColor: UIColor(hex: 0x674290))
        imgPassenger.image = UIImage(fromHex: JetExFontHexCode.jetexPassengers.rawValue, withColor: UIColor.white)
        imgRightArrow.image = UIImage(fromHex: JetExFontHexCode.oneWay.rawValue, withColor: UIColor.white)
    }
}
