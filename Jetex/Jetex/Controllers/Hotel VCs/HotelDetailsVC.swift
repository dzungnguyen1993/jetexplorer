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
import ImageSlideshow

class HotelDetailsVC: BaseViewController {
    
    var searchInfo: SearchHotelInfo!
    var searchResult: SearchHotelResult!
    
    // Header
    @IBOutlet weak var imgPassenger: UIImageView!
    @IBOutlet weak var imgRightArrow: UIImageView!
    @IBOutlet weak var viewDateDepart: SearchResultDateView!
    @IBOutlet weak var viewDateReturn: SearchResultDateView!
    @IBOutlet weak var viewRoundtrip: UIView!
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbGuest: UILabel!
    @IBOutlet weak var lbRoom: UILabel!
    
    // Hero section
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var rateScoreInHeroLabel: UILabel!
    @IBOutlet weak var rateDescriptionInHeroLabel: UILabel!
    @IBOutlet weak var rateCountInHeroLabel: UILabel!
    
    
    // Info View
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelAddressLabel: UILabel!
    @IBOutlet weak var hotelShortDescriptionLabel: UILabel!
    
    // Main View
        // - Menu
    @IBOutlet var menuButtons: [UITabbarButton]!
        // - Content
    @IBOutlet weak var menuContentsView: UIView!
    
    // Description
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // Amenities
    @IBOutlet weak var amenitiesCollectionView: UICollectionView!
        // - Mock up
    var amenities = [("24-hour front desk", JetExFontHexCode.jetexAmenities24h.rawValue),
                     ("Luggate storage", JetExFontHexCode.jetexAmenitiesLuggage.rawValue),
                     ("Babysitting or childcare", JetExFontHexCode.jetexAmenitiesChildcare.rawValue),
                     ("Free WiFi", JetExFontHexCode.jetexAmenitiesWifi.rawValue),
                     ("Coffee shop or café", JetExFontHexCode.jetexAmenitiesCoffee.rawValue),
                     ("Breakfast available (surcharge)", JetExFontHexCode.jetexAmenitiesBreakfast.rawValue),
                     ("Full-service spa", JetExFontHexCode.jetexAmenitiesSpa.rawValue),
                     ("Fitness facilities", JetExFontHexCode.jetexAmenitiesGym.rawValue),
                     ("ATM/banking", JetExFontHexCode.jetexAmenitiesATM.rawValue),
                     ("Outdoor pool", JetExFontHexCode.jetexAmenitiesPool.rawValue),
                     ("Casino", JetExFontHexCode.jetexAmenitiesCasino.rawValue),
                     ("Dry cleaning/ laundry service", JetExFontHexCode.jetexAmenitiesLaundry.rawValue),
                     ("Limo or Town Car service available", JetExFontHexCode.jetexAmenitiesCar.rawValue),
                     ("Elevator/lift", JetExFontHexCode.jetexAmenitiesElevator.rawValue)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeroSection()
        setUpMenuInMainViewSection()
        setUpAnemitiesSection()
        
        
        // show header info
        showHeaderInfo()
        setupImagesInHeader()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func menuButtonPressed(_ title: String) {
        for button in menuButtons {
            if button.title != title {
                button.isSelected = false
            } else {
                button.isSelected = true
            }
        }
    }
    
    func dealsButtonPressed() {
        self.menuButtonPressed(MenuButtonType.Deals.getString())
    }
    
    func reviewsButtonPressed() {
        self.menuButtonPressed(MenuButtonType.Reviews.getString())
        
    }
    
    func mapButtonPressed() {
        self.menuButtonPressed(MenuButtonType.Map.getString())
        
    }
    
    func amenitiesButtonPressed() {
        self.menuButtonPressed(MenuButtonType.Amenities.getString())
        
    }
}

// MARK: Setup UI
extension HotelDetailsVC {
    func showHeaderInfo() {
        lbCity.text = searchInfo.city?.name
        let country = DBManager.shared.getCountry(fromCity: searchInfo.city!)
        lbCountry.text = country?.name
        viewDateDepart.lbDate.text = searchInfo.checkinDay?.toDay()
        viewDateDepart.lbMonth.text = searchInfo.checkinDay?.toMonth()
        viewDateReturn.lbDate.text = searchInfo.checkoutDay?.toDay()
        viewDateReturn.lbMonth.text = searchInfo.checkoutDay?.toMonth()
    }
    
    func setupImagesInHeader() {
        imgPassenger.image = UIImage(fromHex: JetExFontHexCode.jetexPassengers.rawValue, withColor: UIColor.white)
        imgRightArrow.image = UIImage(fromHex: JetExFontHexCode.oneWay.rawValue, withColor: UIColor.white)
    }
    
    func setupHeroSection() {
        
        self.imageSlideShow.slideshowInterval = 10 // 3 seconds
        self.imageSlideShow.contentScaleMode = .scaleAspectFill // fill mode
        self.imageSlideShow.pageControlPosition = .hidden
        
        // mock data
        self.imageSlideShow.setImageInputs([
            AlamofireSource(urlString: "https://cdn-image.travelandleisure.com/sites/default/files/styles/destination_guide_tout/public/1445965295/hotel-muse-bangkok-bk1015.jpg")!,
            AlamofireSource(urlString: "https://r-ec.bstatic.com/images/hotel/max500/630/63070696.jpg")!,
            AlamofireSource(urlString: "https://www.kayak.com.hk/rimg/himg/d5/5c/48/leonardo-1118279-BTTHBK_SN_0711_Pool_S-image.jpg")!])
       
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HotelDetailsVC.didTapTheImageInHero))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
    }
    
    func didTapTheImageInHero() {
        
        let vc = imageSlideShow.presentFullScreenController(from: self)
        let screnSize = UIScreen.main.bounds.size
        
        UIView.animate(withDuration: 0.0) {
            vc.closeButton.center = CGPoint(x: screnSize.width - 32, y: 48)
        }
    }
    
    func setUpMainViewSection() {
        setUpMenuInMainViewSection()
    }
    
    func setUpMenuInMainViewSection() {
        let dealsGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HotelDetailsVC.dealsButtonPressed))
        let reviewsGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HotelDetailsVC.reviewsButtonPressed))
        let mapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HotelDetailsVC.mapButtonPressed))
        let amenitiesGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HotelDetailsVC.amenitiesButtonPressed))
        
        menuButtons[MenuButtonType.Deals.rawValue].addGestureRecognizer(dealsGestureRecognizer)
        menuButtons[MenuButtonType.Reviews.rawValue].addGestureRecognizer(reviewsGestureRecognizer)
        menuButtons[MenuButtonType.Map.rawValue].addGestureRecognizer(mapGestureRecognizer)
        menuButtons[MenuButtonType.Amenities.rawValue].addGestureRecognizer(amenitiesGestureRecognizer)
    }
    
    func setUpAnemitiesSection() {
        
        // collection view
        self.amenitiesCollectionView.register(UINib(nibName: "AmenityCell", bundle: nil), forCellWithReuseIdentifier: "AmenityCell")
        self.amenitiesCollectionView.delegate = self
        self.amenitiesCollectionView.dataSource = self
    }
}

// MARK: Set up Collection of Amenities

extension HotelDetailsVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmenityCell", for: indexPath) as! AmenityCell
        
        let amenity = self.amenities[indexPath.row]
        cell.label.text = amenity.0
        cell.label.textColor = UIColor(hex: 0x674290)
        cell.imgView.image = UIImage(fromHex: amenity.1, withColor: (UIColor(hex: 0x674290)))
        
        return cell
    }
}

extension HotelDetailsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HotelDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: 76)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
