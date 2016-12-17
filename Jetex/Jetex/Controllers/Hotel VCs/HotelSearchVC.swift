//
//  HotelSearchVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 12/16/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class HotelSearchVC: UIViewController {

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
    }
    
    func addActionForViews() {
        let tapCity = UITapGestureRecognizer(target: self, action: #selector(pickCity(sender:)))
        viewLocation.addGestureRecognizer(tapCity)
        
        let tapCheckin = UITapGestureRecognizer(target: self, action: #selector(pickCheckin(sender:)))
        viewCheckin.addGestureRecognizer(tapCheckin)
        
        let tapCheckout = UITapGestureRecognizer(target: self, action: #selector(pickCheckout(sender:)))
        viewCheckout.addGestureRecognizer(tapCheckout)
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

