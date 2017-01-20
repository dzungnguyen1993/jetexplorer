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
    
    var searchResult: SearchHotelResult!
    var hotels: [Hotel]! = nil
    
    var isShowCheapest: Bool!
    var isShowDetailsBefore: Bool!
    var currentSearchedCurrency: String = "USD"
    
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbGuest: UILabel!
    @IBOutlet weak var lbRoom: UILabel!
    
    @IBOutlet weak var constraintFilterHeight: NSLayoutConstraint!
    @IBOutlet weak var viewFilter: FilterHotelView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgCancel: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: "HotelResultCell", bundle: nil), forCellReuseIdentifier: "HotelResultCell")
        
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
        if (searchResult != nil) {
            if (ProfileVC.currentCurrencyType == currentSearchedCurrency) {
                return
            }
        }
        
        searchForHotels()
        // setup filter
   
        viewFilter.delegate = self
        constraintFilterHeight.constant = 1022
    }
    
    func searchForHotels() {
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
        
        NetworkManager.shared.requestGetHotelSearchResult(info: searchInfo) { (isSuccess, data) in
            
            if (isSuccess) {
                loadingVC.updateProgress(percent: 90)
                self.currentSearchedCurrency = ProfileVC.currentCurrencyType
                self.searchResult = ResponseParser.shared.parseHotelSearchResponse(data: data as! NSDictionary)
                loadingVC.updateProgress(percent: 100, completion: {
                    popup.dismiss()
                })
                
                self.loadResult()
                
                if self.searchResult.hotels.count != 0 {
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
        self.searchResult.initSort()
        self.loadResultData()
        
        // update constraint of collection view of amenity
        // 76 is cell height
        // 580 is height of the rest of view
        self.constraintFilterHeight.constant = 490 + CGFloat(76 * (Int(self.searchResult.amenities.count) + 1)/2)
        self.viewFilter.setFilterInfo(searchResult: self.searchResult)
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
    
    @IBAction func showBestTrip(_ sender: UIButton) {
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
        
        viewFilter.loadData()
    }
    
    @IBAction func backToSearch(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func showMap(_ sender: UIButton) {
        let vc = MapFullScreenVC(nibName: "MapFullScreenVC", bundle: nil)
        vc.searchInfo = self.searchInfo
        vc.mapType = .cityMap
//        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func hideFilter(_ sender: Any) {
        self.hideFilter()
    }
}

// MARK: Setup UI
extension HotelResultVC {
    func showHeaderInfo() {
        lbCity.text = searchInfo.city?.name
        let country = DBManager.shared.getCountry(fromCity: searchInfo.city!)
        lbCountry.text = country?.name
        viewDateDepart.lbDate.text = searchInfo.checkinDay?.toDay()
        viewDateDepart.lbMonth.text = searchInfo.checkinDay?.toMonth()
        viewDateReturn.lbDate.text = searchInfo.checkoutDay?.toDay()
        viewDateReturn.lbMonth.text = searchInfo.checkoutDay?.toMonth()
        lbGuest.text = searchInfo.numberOfGuest.toString()
        if (searchInfo.numberOfRooms == 1) {
            lbRoom.text = searchInfo.numberOfRooms.toString() + "room"
        } else {
            lbRoom.text = searchInfo.numberOfRooms.toString() + "rooms"
        }
        
    }
    
    func setupImages() {
        imgFilter.image = UIImage(fromHex: JetExFontHexCode.jetexSliders.rawValue, withColor: UIColor(hex: 0x674290))
        imgPassenger.image = UIImage(fromHex: JetExFontHexCode.jetexPassengers.rawValue, withColor: UIColor.white)
        imgRightArrow.image = UIImage(fromHex: JetExFontHexCode.oneWay.rawValue, withColor: UIColor.white)
        imgMap.image = UIImage(fromHex: JetExFontHexCode.jetexMap.rawValue, withColor: (UIColor(hex: 0x674290)))
        imgCancel.image = UIImage(fromHex: JetExFontHexCode.jetexCross.rawValue, withColor: UIColor(hex: 0x515151))
    }
}

// MARK: Table view
extension HotelResultVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard hotels != nil else {return 0}
        return hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelResultCell", for: indexPath) as! HotelResultCell
        
        cell.containerView.layer.borderColor = UIColor(hex: 0xD6D6D6).cgColor
        cell.containerView.layer.borderWidth = 1.0
        
        // set hotel info
        let hotel = self.hotels[indexPath.row]
        
        // set popularity
        let score = Double(hotel.popularity) / 10
        cell.lbPopularity.text = score.toString() + " " + hotel.popularityDesc
        
        cell.lbHotelName.text = hotel.name
        cell.lbDistance.text = hotel.distance.toString() + "km to centre"
        
        // show stars
        cell.showStars(star: hotel.star)
        
        // set price
        let agentPrice = self.searchResult.getPrice(ofHotel: hotel)
        if agentPrice != nil {
            cell.lbPrice.text = ProfileVC.currentCurrencyType + " " + (agentPrice?.priceTotal.toString())!
            let pricePerNight = (agentPrice?.priceTotal)! / Double((searchInfo.checkoutDay?.days(fromDate: searchInfo.checkinDay!))!)
            cell.lbPricePerNight.text = ProfileVC.currentCurrencyType + " " + (pricePerNight.toString()) + "/night"
            
        }

        cell.selectionStyle = .none
        
        // download image
        cell.hotelImg.image = nil
        Alamofire.request(hotel.getImageUrl()).responseImage { response in
            if let image = response.result.value {
                let cell = self.tableView.cellForRow(at: indexPath) as? HotelResultCell
                if cell != nil {
                    DispatchQueue.main.async {
                        cell?.hotelImg.image = image
                    }
                }
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height of image (ratio 21:9) + the rest
        return 120 + self.view.frame.size.width * 9 / 21
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // show popup
        let loadingVC = InitialLoadingPopupVC(nibName: "InitialLoadingPopupVC", bundle: nil)
        loadingVC.initView(title: "Loading...", message: "Loading detail information for the hotel")
        
        let popUpVC = PopupDialog(viewController: loadingVC, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
        self.present(popUpVC, animated: true, completion: nil)
        
        //load detail first
        self.getHotelInfoInDetail(hotelId: self.hotels[indexPath.row].id) { (result) in
            popUpVC.dismiss()
            if let result = result {
                let vc = HotelDetailsVC(nibName: "HotelDetailsVC", bundle: nil)
                vc.searchInfo = self.searchInfo
                vc.hotel = self.hotels[indexPath.row]
                vc.hotelInDetailResult = result
                vc.pickedHotel = self.hotels[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let popUpVC = PopupDialog(title: "Fail", message: "Couldn't load detail information for the hotel, please try again!")
                popUpVC.addButton(CancelButton(title: "Cancel", dismissOnTap: true, action: nil))
                self.present(popUpVC, animated: true, completion: nil)
            }
        }
    }
}


// load data
extension HotelResultVC {
    func loadResultData() {
        if (isShowCheapest == true) {
            hotels = self.searchResult.cheapestHotels
        } else {
            hotels = self.searchResult.bestHotels
        }

        let sections = NSIndexSet(indexesIn: NSMakeRange(0, tableView.numberOfSections))
        tableView.reloadSections(sections as IndexSet, with: .automatic)
        self.tableView.reloadData()
        
        guard self.hotels.count > 0 else {return}
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func getHotelInfoInDetail(hotelId: Int, completion: ((HotelinDetailResult?) -> Void)? = nil) {
        let url = "\(APIURL.JetExAPI.base)\(APIURL.JetExAPI.getHotelDetailInfo)/\(hotelId)"
        
        Alamofire.request(url, method: .get, parameters: nil).responseJSON { (response) in
            if let data = response.result.value as? [String: Any] {
                let hotelInDetailResult = HotelinDetailResult(JSON: data)
                completion?(hotelInDetailResult)
            }
        }
        
    }
}

// MARK: Filter
extension HotelResultVC: FilterHotelViewDelegate {
    func hideFilter() {
        UIView.animate(withDuration: 0.25, animations: {
            self.viewFilterContainer.isHidden = true
            self.viewOptions.isHidden = false
            self.tableView.isHidden = false
        })
        
        self.scrollFilterToTop()
    }
    
    func applyFilter(filterObject: FilterHotelObject) {
        searchResult.applyFilter(filterObject: filterObject)
        
        hideFilter()
        
        loadResultData()
        
        self.scrollFilterToTop()
    }
    
    func scrollFilterToTop() {
        self.scrollView.contentOffset = CGPoint.zero
    }
}
