//
//  FlightResultVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/15/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import PopupDialog
import Alamofire

class FlightResultVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewOptions: UIView!
    @IBOutlet weak var viewFilterContainer: UIView!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var viewNoResult: UIView!
    
    var viewFilter: FilterFlightView!
    
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
    var passengerInfo: PassengerInfo! // = PassengerInfo() no need
    
    @IBOutlet weak var lbOrigin: UILabel!
    @IBOutlet weak var transferImage: UIImageView!
    @IBOutlet weak var lbDestination: UILabel!
    @IBOutlet weak var viewDateDepart: SearchResultDateView!
    @IBOutlet weak var viewDateReturn: SearchResultDateView!
    @IBOutlet weak var lbNumberPassenger: GothamBold17Label!
    
    @IBOutlet weak var viewRoundtrip: UIView!
    @IBOutlet weak var viewOneway: UIView!
    @IBOutlet weak var viewDepartOneway: SearchResultDateView!
    
    var searchFlightResult: SearchFlightResult!
    var itineraries: [Itinerary]! = nil
    
    var isShowCheapest: Bool!
    var isShowDetailsBefore: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: "FlightResultCell", bundle: nil), forCellReuseIdentifier: "FlightResultCell")
        
        self.tableView.separatorStyle = .none
        
        viewOptions.layer.borderWidth = 1.0
        viewOptions.layer.borderColor = UIColor(hex: 0xD6D6D6).cgColor
        
        setupImages()
        
        // show header info
        showHeaderInfo()
        isShowCheapest = true
        isShowDetailsBefore = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard searchFlightResult == nil else {
            return
        }
        
        if (viewFilter == nil) {
            // add view filter
            viewFilter = FilterFlightView(frame: CGRect(x: 0, y: 0, width: viewFilterContainer.frame.size.width, height: viewFilterContainer.frame.size.height))
            viewFilterContainer.addSubview(viewFilter)
            viewFilter.delegate = self
        }
        
        searchForFlights()
    }
    
    func searchForFlights() {
        let loadingVC = LoadingPopupVC(nibName: "LoadingPopupVC", bundle: nil)
        
        let popup = PopupDialog(viewController: loadingVC, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
        loadingVC.titleLabel.text = "Please wait, I am searching..."
        loadingVC.updateProgress(percent: 0)
        
        popup.addButton(CancelButton(title: "Cancel", action: {
            loadingVC.updateProgress(percent: 0, completion: {
                print("cancel")
            })
            _ = self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(popup, animated: true, completion: nil)
        loadingVC.startProgress()
        
        NetworkManager.shared.requestGetFlightSearchResult(info: passengerInfo) { (isSuccess, data) in
            
            if (isSuccess) {
                loadingVC.updateProgress(percent: 90)
                self.searchFlightResult = ResponseParser.shared.parseFlightSearchResponse(data: data as! NSDictionary)
                loadingVC.updateProgress(percent: 100, completion: {
                    popup.dismiss()
                })
                
                self.loadResult()
                
                if self.searchFlightResult.itineraries.count != 0 {
                    self.viewNoResult.isHidden = true
                    //TODO: start checking for session timer here
                    
                } else {
                    self.viewNoResult.isHidden = false
                }
            } else {
                loadingVC.updateProgress(percent: 100, completion: {
                    popup.dismiss()
                })
                self.viewNoResult.isHidden = false
            }
        }
    }
    
    func loadResult() {
        self.searchFlightResult.initSort()
        self.loadResultData()
        
        // load filter view
        self.viewFilter.setFilterInfo(searchResult: self.searchFlightResult, origin: passengerInfo.airportFrom!, destination: passengerInfo.airportTo!)
    }
   
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func showCheapestTrip(_ sender: UIButton) {
        btnCheapest.alpha = 1.0
        viewUnderCheapest.isHidden = false
        
        btnFastest.alpha = 0.6
        viewUnderFastest.isHidden = true
        
        // load result
        isShowCheapest = true
        isShowDetailsBefore = false
        loadResultData()
    }
    
    @IBAction func showFastestTrip(_ sender: UIButton) {
        btnCheapest.alpha = 0.6
        viewUnderCheapest.isHidden = true
        
        btnFastest.alpha = 1.0
        viewUnderFastest.isHidden = false
        
        // load result
        isShowCheapest = false
        isShowDetailsBefore = false
        loadResultData()
    }
    
    @IBAction func showFilter(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.viewFilterContainer.isHidden = false
            self.viewOptions.isHidden = true
            self.tableView.isHidden = true
        })
        
        viewFilter.tmpFilterObject = viewFilter.filterObject.copyFilter()
        viewFilter.tableView.reloadData()
    }
    
    @IBAction func backToSearch(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
}

// MARK: Setup UI
extension FlightResultVC {
    func showHeaderInfo() {
        lbOrigin.text = passengerInfo.airportFrom?.id
        lbDestination.text = passengerInfo.airportTo?.id
        lbNumberPassenger.text = String(passengerInfo.numberOfPassenger())
    
        if (!passengerInfo.isRoundTrip) {
            viewRoundtrip.isHidden = true
            viewOneway.isHidden = false
            
            viewDepartOneway.lbDate.text = passengerInfo.departDay?.toDay()
            viewDepartOneway.lbMonth.text = passengerInfo.departDay?.toMonth()
            
            transferImage.image = UIImage(named: "right-arrow.png")
        } else {
            viewRoundtrip.isHidden = false
            viewOneway.isHidden = true
            
            viewDateDepart.lbDate.text = passengerInfo.departDay?.toDay()
            viewDateDepart.lbMonth.text = passengerInfo.departDay?.toMonth()
            viewDateReturn.lbDate.text = passengerInfo.returnDay?.toDay()
            viewDateReturn.lbMonth.text = passengerInfo.returnDay?.toMonth()
            transferImage.image = UIImage(named: "transfer.png")
        }
    }
    
    func setupImages() {
        imgFilter.image = UIImage(fromHex: JetExFontHexCode.jetexSliders.rawValue, withColor: UIColor(hex: 0x674290))
        imgPassenger.image = UIImage(fromHex: JetExFontHexCode.jetexPassengers.rawValue, withColor: UIColor.white)
        imgRightArrow.image = UIImage(fromHex: JetExFontHexCode.oneWay.rawValue, withColor: UIColor.white)
    }
}

// MARK: Table view
extension FlightResultVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard itineraries != nil else {
            return 0
        }
        return itineraries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightResultCell", for: indexPath) as! FlightResultCell
        
        if (indexPath.row == showDetailsIndex) {
            cell.viewInfoGeneral.isHidden = true
            cell.viewDetails.isHidden = false
            cell.addDetails(ofSearchResult: searchFlightResult, forItinerary: itineraries[indexPath.row])
            
            // set border
            cell.containerView.layer.borderColor = UIColor(hex: 0x674290).cgColor
            cell.containerView.layer.borderWidth = 1.0
        } else {
            cell.viewInfoGeneral.isHidden = false
            cell.viewDetails.isHidden = true
            
            // set border
            cell.containerView.layer.borderColor = UIColor(hex: 0xD6D6D6).cgColor
            cell.containerView.layer.borderWidth = 1.0
        }
        // selecting color -> default
        cell.selectionStyle = .none
        
        cell.showInfo(ofSearchResult: searchFlightResult, forItinerary: itineraries[indexPath.row])
        
        // download cell image
        cell.imgCarrier.image = nil
        // download carrier image
        
        let leg = searchFlightResult.getLeg(withId: itineraries[indexPath.row].outboundLegId)
        
        // update constraint when there's no image
        cell.imgCarrier.removeConstraint((cell.constraintLogoRatio)!)
        
        cell.constraintLogoRatio = NSLayoutConstraint(item: (cell.imgCarrier)!, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: cell.imgCarrier, attribute: NSLayoutAttribute.height, multiplier: 0, constant: 0)
        cell.imgCarrier.addConstraint((cell.constraintLogoRatio)!)
        
        if (leg != nil) {
            let carrier = searchFlightResult.getCarrier(withId: (leg?.carriers.first)!)
            
            if (carrier != nil) {
                Alamofire.request((carrier?.imageUrl)!).responseImage { response in
                    if let image = response.result.value {
                        let ratio = image.size.width / image.size.height
                        
                        // remove old constraint
                        let cell = self.tableView.cellForRow(at: indexPath) as? FlightResultCell
                        if cell != nil {
                            DispatchQueue.main.async {
                                cell?.imgCarrier.removeConstraint((cell?.constraintLogoRatio)!)
                                
                                cell?.constraintLogoRatio = NSLayoutConstraint(item: (cell?.imgCarrier)!, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: cell?.imgCarrier, attribute: NSLayoutAttribute.height, multiplier: ratio, constant: 0)
                                cell?.imgCarrier.addConstraint((cell?.constraintLogoRatio)!)
                                
                                cell?.imgCarrier.image = image
                            }

                        }
                    }
                }

            }
        }
       
        cell.setNeedsUpdateConstraints()
        cell.setNeedsLayout()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var footerSize = 8
        if (indexPath.row == itineraries.count - 1) {
            footerSize = 0
        }
        
        if (indexPath.row == showDetailsIndex) {
            return CGFloat(56 + 8 + FlightCellUtils.heightForDetailsOfFlightInfo(ofSearchResult: searchFlightResult, forItinerary: itineraries[indexPath.row]) + footerSize)
        }
        
        return CGFloat(cellDefaultHeight + footerSize)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (showDetailsIndex != indexPath.row) {
            showDetailsIndex = indexPath.row
        } else {
            showDetailsIndex = -1
        }
     
        if (self.isShowDetailsBefore == false) {
            self.isShowDetailsBefore = true
            self.tableView.reloadData()
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .middle)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
//        let sections = NSIndexSet(indexesIn: NSMakeRange(0, tableView.numberOfSections))
//        tableView.reloadSections(sections as IndexSet, with: .automatic)
//        tableView.reloadData()
    }
}

// MARK: Filter
extension FlightResultVC: FilterFlightViewDelegate {
    func hideFilter() {
        UIView.animate(withDuration: 0.25, animations: {
            self.viewFilterContainer.isHidden = true
            self.viewOptions.isHidden = false
            self.tableView.isHidden = false
        })
    }
    
    func applyFilter(filterObject: FilterObject) {
        searchFlightResult.applyFilter(filterObject: filterObject)
    
        hideFilter()
        
        loadResultData()
    }
}

// load data
extension FlightResultVC {
    func loadResultData() {
        if (isShowCheapest == true) {
            itineraries = self.searchFlightResult.cheapestTrips
        } else {
            itineraries = self.searchFlightResult.fastestTrips
        }
        showDetailsIndex = -1
        let sections = NSIndexSet(indexesIn: NSMakeRange(0, tableView.numberOfSections))
        tableView.reloadSections(sections as IndexSet, with: .automatic)
        self.tableView.reloadData()
        
        guard self.itineraries.count > 0 else {return}
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
