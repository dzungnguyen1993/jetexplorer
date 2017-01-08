//
//  HotelSearchVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 12/16/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import PopupDialog

class HotelSearchVC: BaseViewController {

    // MARK: Initialization
    @IBOutlet weak var viewLocation: PickInfoView!
    @IBOutlet weak var viewCheckin: PickInfoView!
    @IBOutlet weak var viewCheckout: PickInfoView!
    
    var searchHotelInfo: SearchHotelInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchHotelInfo = SearchHotelInfo()
        self.searchHotelInfo.initialize()
        
        self.initViews()
        self.setImages()
        
        // add tap actions
        self.addActionForViews()
    }

    func initViews() {
        viewLocation.lbTitle.text = "Where ?"
        
        if (searchHotelInfo.city != nil) {
            viewLocation.lbInfo.text = searchHotelInfo.city?.name
        } else {
            viewLocation.lbInfo.text = "--"
        }
        
        viewCheckin.lbTitle.text = "Check in"
        viewCheckout.lbTitle.text = "Check out"
     
        self.showDateInfo()
    }
    
    @IBAction func search(_ sender: Any) {
        // check if info is valid
        if (searchHotelInfo.city == nil) {
            self.showErrorAlert(message: "You didn't choose the location.")
            return
        }
        
        gotoResultVC()
    }
    
    func showErrorAlert(message: String) {
        let popup = PopupDialog(title: message, message: "", image: nil, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: true, completion: nil)
        let buttonOne = CancelButton(title: "CANCEL") {
            popup.dismiss()
        }
        
        popup.addButton(buttonOne)
        self.present(popup, animated: true, completion: nil)
    }
    
    func gotoResultVC() {
        // save searching info into history
        saveSearchingInfoIntoHistory()
        
        let vc = HotelResultVC(nibName: "HotelResultVC", bundle: nil)
        vc.searchInfo = self.searchHotelInfo
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func addActionForViews() {
        let tapCity = UITapGestureRecognizer(target: self, action: #selector(pickCity(sender:)))
        viewLocation.addGestureRecognizer(tapCity)
        
        let tapCheckin = UITapGestureRecognizer(target: self, action: #selector(pickCheckin(sender:)))
        viewCheckin.addGestureRecognizer(tapCheckin)
        
        let tapCheckout = UITapGestureRecognizer(target: self, action: #selector(pickCheckout(sender:)))
        viewCheckout.addGestureRecognizer(tapCheckout)
    }
    
    func saveSearchingInfoIntoHistory() {
        let currentSearchHotelInfo = SearchHotelInfo(searchHotelInfo: self.searchHotelInfo)
        let hotelHistorySearch = HotelHistorySearch(info: currentSearchHotelInfo, searchAt: Date())
        let searchingHistory = HistorySearch(type: .Hotel, flight: nil, hotel: hotelHistorySearch)
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(searchingHistory)
        }
        
        let historyList = Array(realm.objects(HistorySearch.self))
        
        if ProfileVC.isUserLogined {
            // user login, sync to server and save to current user
            let JSONlist = HistorySearch.historyListToJSON(historyList: historyList)
            
            NetworkManager.shared.syncHistoryToServer(historyData: JSONlist, completion: { (success, result) in
                if success {
                    // sync success.
                    let realm = try! Realm()
                    try! realm.write {
                        searchingHistory.isSynced = true
                    }
                } else {
                    // sync fail, saved it to nowhere in local.
                }
            })
        } else {
            // user is not loged in, save it o nowhere in local
            try! realm.write {
                realm.add(searchingHistory)
            }
        }
    }
}

extension HotelSearchVC {
    func pickCity(sender: UITapGestureRecognizer) {
        let vc = CitySearchVC(nibName: "CitySearchVC", bundle: nil)
        vc.delegate = self
        vc.currentCity = self.searchHotelInfo.city
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pickCheckin(sender: UITapGestureRecognizer) {
        gotoPickDateVC(indicatorPosition: .checkIn)
    }
    
    func pickCheckout(sender: UITapGestureRecognizer) {
        gotoPickDateVC(indicatorPosition: .checkOut)
    }
}

// setup layout
extension HotelSearchVC {
    func setImages() {
        self.viewLocation.imgView.image = UIImage(fromHex: JetExFontHexCode.jetexPin.rawValue, withColor: UIColor(hex: 0x674290))
        self.viewCheckin.imgView.image = UIImage(fromHex: JetExFontHexCode.jetexCheckin.rawValue, withColor: UIColor(hex: 0x674290))
        self.viewCheckout.imgView.image = UIImage(fromHex: JetExFontHexCode.jetexCheckout.rawValue, withColor: UIColor(hex: 0x674290))
    }
}

extension HotelSearchVC: PickCityDelegate {
    func didPickLocation(city: City) {
        searchHotelInfo.city = city
        viewLocation.lbInfo.text = city.name
        let country = DBManager.shared.getCountry(fromCity: city)
        viewLocation.lbSubInfo.text = country?.name
    }
}

extension HotelSearchVC: PickDateVCDelegate {
    // MARK: Pick date
    func gotoPickDateVC(indicatorPosition: IndicatorPosition) {
        let vc = PickDateVC(nibName: "PickDateVC", bundle: nil)
        vc.indicatorPosition = indicatorPosition
        vc.checkInDate = searchHotelInfo.checkinDay
        vc.checkOutDate = searchHotelInfo.checkoutDay
        vc.delegate = self
        vc.viewCheckinTitle = "Check in"
        vc.viewCheckoutTitle = "Check out"
        vc.type = .roundtrip
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didFinishPickDate(checkInDate: Date?, checkOutDate: Date?) {
        searchHotelInfo.checkinDay = checkInDate
        searchHotelInfo.checkoutDay = checkOutDate
        
        showDateInfo()
    }
    
    func showDateInfo() {
        guard searchHotelInfo.checkinDay != nil else {return}
        viewCheckin.lbInfo.text = searchHotelInfo.checkinDay?.toMonthDay()
        viewCheckin.lbSubInfo.text = searchHotelInfo.checkoutDay?.toWeekDay()
        
        guard searchHotelInfo.checkoutDay != nil else {return}
        viewCheckout.lbInfo.text = searchHotelInfo.checkoutDay?.toMonthDay()
        viewCheckout.lbSubInfo.text = searchHotelInfo.checkoutDay?.toWeekDay()
    }
}

