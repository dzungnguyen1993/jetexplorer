//
//  HotelResultVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 12/18/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import PopupDialog
import Alamofire

class HotelResultVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewOptions: UIView!
    @IBOutlet weak var viewFilterContainer: UIView!
    @IBOutlet weak var viewNoResult: UIView!
    
    @IBOutlet weak var btnCheapest: UIButton!
    @IBOutlet weak var viewUnderCheapest: UIView!
    
    @IBOutlet weak var btnFastest: UIButton!
    @IBOutlet weak var viewUnderFastest: UIView!
    
    @IBOutlet weak var imgFilter: UIImageView!
    @IBOutlet weak var imgPassenger: UIImageView!
    @IBOutlet weak var imgRightArrow: UIImageView!
    @IBOutlet weak var imgMap: UIImageView!
    
    var searchInfo: SearchHotelInfo!
    
    @IBOutlet weak var viewDateDepart: SearchResultDateView!
    @IBOutlet weak var viewDateReturn: SearchResultDateView!
    
    @IBOutlet weak var viewRoundtrip: UIView!
    
    var searchFlightResult: SearchFlightResult!
    var itineraries: [Itinerary]! = nil
    
    var isShowCheapest: Bool!
    var isShowDetailsBefore: Bool!
    
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbGuest: UILabel!
    @IBOutlet weak var lbRoom: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
//        self.tableView.register(UINib(nibName: "FlightResultCell", bundle: nil), forCellReuseIdentifier: "FlightResultCell")/
        
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
        
        searchForFlights()
    }
    
    func searchForFlights() {
//        let loadingVC = LoadingPopupVC(nibName: "LoadingPopupVC", bundle: nil)
//        
//        let popup = PopupDialog(viewController: loadingVC, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
//        loadingVC.titleLabel.text = "Please wait, I am searching..."
//        loadingVC.updateProgress(percent: 0)
//        
//        popup.addButton(CancelButton(title: "Cancel", action: {
//            loadingVC.updateProgress(percent: 0, completion: {
//                print("cancel")
//            })
//            _ = self.navigationController?.popViewController(animated: true)
//        }))
//        
//        self.present(popup, animated: true, completion: nil)
//        loadingVC.startProgress()
//        
//        NetworkManager.shared.requestGetFlightSearchResult(info: passengerInfo) { (isSuccess, data) in
//            
//            if (isSuccess) {
//                loadingVC.updateProgress(percent: 90)
//                self.searchFlightResult = ResponseParser.shared.parseFlightSearchResponse(data: data as! NSDictionary)
//                loadingVC.updateProgress(percent: 100, completion: {
//                    popup.dismiss()
//                })
//                
//                self.loadResult()
//                
//                if self.searchFlightResult.itineraries.count != 0 {
//                    self.viewNoResult.isHidden = true
//                    //TODO: start checking for session timer here
//                    
//                } else {
//                    self.viewNoResult.isHidden = false
//                }
//            } else {
//                loadingVC.updateProgress(percent: 100, completion: {
//                    popup.dismiss()
//                })
//                self.viewNoResult.isHidden = false
//            }
//        }
    }
    
    func loadResult() {
        
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
//        loadResultData()
    }
    
    @IBAction func showFastestTrip(_ sender: UIButton) {
        btnCheapest.alpha = 0.6
        viewUnderCheapest.isHidden = true
        
        btnFastest.alpha = 1.0
        viewUnderFastest.isHidden = false
        
        // load result
        isShowCheapest = false
        isShowDetailsBefore = false
//        loadResultData()
    }
    
    @IBAction func showFilter(_ sender: UIButton) {
        
//        UIView.animate(withDuration: 0.25, animations: {
//            self.viewFilterContainer.isHidden = false
//            self.viewOptions.isHidden = true
//            self.tableView.isHidden = true
//        })
//        
//        viewFilter.tableView.reloadData()
    }
    
    @IBAction func backToSearch(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func showMap(_ sender: UIButton) {
        
    }
}

// MARK: Setup UI
extension HotelResultVC {
    func showHeaderInfo() {
        lbCity.text = searchInfo.city?.name
        lbCountry.text = ""
        viewDateDepart.lbDate.text = searchInfo.checkinDay?.toDay()
        viewDateDepart.lbMonth.text = searchInfo.checkinDay?.toMonth()
        viewDateReturn.lbDate.text = searchInfo.checkoutDay?.toDay()
        viewDateReturn.lbMonth.text = searchInfo.checkoutDay?.toMonth()
    }
    
    func setupImages() {
        imgFilter.image = UIImage(fromHex: JetExFontHexCode.jetexSliders.rawValue, withColor: UIColor(hex: 0x674290))
        imgPassenger.image = UIImage(fromHex: JetExFontHexCode.jetexPassengers.rawValue, withColor: UIColor.white)
        imgRightArrow.image = UIImage(fromHex: JetExFontHexCode.oneWay.rawValue, withColor: UIColor.white)
        imgMap.image = UIImage(fromHex: JetExFontHexCode.jetexMap.rawValue, withColor: (UIColor(hex: 0x674290)))
    }
}

// MARK: Table view
extension HotelResultVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        }
}
