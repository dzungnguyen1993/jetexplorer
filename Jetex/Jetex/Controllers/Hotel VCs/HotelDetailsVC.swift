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

protocol HotelDetailsVCDelegate: class {
    func resizeContentViewInScrollViewWithNewComponentHeight(newComponentHeight: CGFloat, complete: (() -> Void)?)
    func adjustDealsViewFrameToFit()
    func zoomMapToFullScreen()
}

class HotelDetailsVC: BaseViewController {
    
    var searchInfo: SearchHotelInfo!
    var searchResult: SearchHotelResult!
    var hotelInDetailResult: HotelinDetailResult?
    var pickedHotel: Hotel!

    
    // Height of content's scrollview
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    //let heroViewHeight = 220
    //let mainViewMenuHeight = 48
    // calculate main based view based on heroViewheight and mainViewMenuHeight
    lazy var mainBasedViewHeight : CGFloat = {
        return 220.0 + self.infoView.bounds.height + 48.0
    }()
    
    @IBOutlet weak var detailScrollView: UIScrollView!
    
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
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelAddressLabel: UILabel!
    @IBOutlet weak var hotelShortDescriptionLabel: UILabel!
    
    // Main View
        // - Menu
    @IBOutlet var menuButtons: [UITabbarButton]!
        // - Content
    @IBOutlet weak var menuContentsView: UIView!
        // For animation
    var animationController : ZoomTransition?
    
    // cache views
    var dealsView: DealsView?
    var reviewsView: ReviewsView?
    var mapView: MapInDetailView?
    var amenitiesView : AmenitiesView?
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeroSection()
        setUpMainViewSection()
        
        // show header info
        showHeaderInfo()
        setupImagesInHeader()
        
        //
        bindDataForHeroSection(isViewLoaded: true, initHotelInfo: nil, loadedHotelInfo: self.hotelInDetailResult)
        bindDataForInfoSection(isViewLoaded: true, initHotelInfo: nil, loadedHotelInfo: self.hotelInDetailResult?.hotels.first)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // init deals menu first if it wasn't initialized
        if self.dealsView == nil {
            dealsButtonPressed()
        }
    }
    
    // MARK: - Resize menu content scrollview
    func resizeMenuContentScrollView(newHeight: CGFloat, complete: (() -> Void)?) {
        // set scrollview's content to new height
        self.contentHeightConstraint.constant = newHeight
        
        // animate
        UIView.animate(withDuration: 0.1, animations: {
            self.menuContentsView.layoutIfNeeded()
        }, completion: { (completed) in
            // resize the content of scrollview
            var contentRect = CGRect.zero
            for view in self.detailScrollView.subviews[0].subviews {
                contentRect = contentRect.union(view.frame)
            }
            
            self.detailScrollView.contentSize = contentRect.size;
            
            // do the complete steps
            complete?()
        })
    
    }
    
    // MARK:- Menu Button Pressed functions
    func menuButtonPressed(_ title: String) -> Bool{
        for button in menuButtons {
            if button.title != title {
                button.isSelected = false
            } else {
                if button.isSelected == true {
                    return false
                }
                button.isSelected = true
            }
        }
        
        // remove all the subviews in content view
        for subview in self.menuContentsView.subviews {
            subview.removeFromSuperview()
        }
        
        return true
    }
    
    func dealsButtonPressed() {
        if self.menuButtonPressed(MenuButtonType.Deals.getString()) {
            // resize the size (the height) of menuContentView for fitting with the dealsView
            let newHeight = mainBasedViewHeight + DealsView.height
            
            self.resizeMenuContentScrollView(newHeight: newHeight, complete: { 
                // create a dealsview if it is the first time
                if self.dealsView == nil {
                    self.dealsView = DealsView(frame: self.menuContentsView.bounds)
                    self.dealsView?.delegate = self
                    self.bindDataForVouncherInMainSection(isViewLoaded: true, loadedHotelInfo: self.hotelInDetailResult)
                } else {
                    // adjust the size if needed
                    self.adjustDealsViewFrameToFit()
                }
                
                // insert deals view in
                self.menuContentsView.addSubview(self.dealsView!)
            })
        }
    }
    
    func reviewsButtonPressed() {
        if self.menuButtonPressed(MenuButtonType.Reviews.getString()) {
            // resize the size (the height) of menuContentView for fitting with the dealsView
            let newHeight = mainBasedViewHeight + ReviewsView.height
            
            self.resizeMenuContentScrollView(newHeight: newHeight, complete: {
                // create a dealsview if it is the first time
                if self.reviewsView == nil {
                    self.reviewsView = ReviewsView(frame: self.menuContentsView.bounds)
                    self.bindDataForReviewsInMainSection(isViewLoaded: true, loadedHotelInfo: self.hotelInDetailResult)
                } else {
                    self.adjustReviewsViewFrameToFit()
                }
                
                // insert deals view in
                self.menuContentsView.addSubview(self.reviewsView!)
            })
        }
    }
    
    func mapButtonPressed() {
        if self.menuButtonPressed(MenuButtonType.Map.getString()) {
            // resize the size (the height) of menuContentView for fitting with the dealsView
            let newHeight = mainBasedViewHeight + MapInDetailView.height
            
            self.resizeMenuContentScrollView(newHeight: newHeight, complete: {
                // create a dealsview if it is the first time
                if self.mapView == nil {
                    self.mapView = MapInDetailView(frame: self.menuContentsView.bounds)
                    self.mapView?.delegate = self
                    self.mapView?.initMap(withWidth: self.menuContentsView.bounds.width)
                    self.mapView?.bindingData(hotelInfo: self.hotelInDetailResult!.hotels.first!)
                }
                
                // insert deals view in
                self.menuContentsView.addSubview(self.mapView!)
            })
        }
    }
    
    func amenitiesButtonPressed() {
        if self.menuButtonPressed(MenuButtonType.Amenities.getString()) {
            // resize the size (the height) of menuContentView for fitting with the dealsView
            let newHeight = mainBasedViewHeight + AmenitiesView.height
            
            self.resizeMenuContentScrollView(newHeight: newHeight, complete: {
                // create a dealsview if it is the first time
                if self.amenitiesView == nil {
                    self.amenitiesView = AmenitiesView(frame: self.menuContentsView.bounds)
                    self.bindDataForAmenitiesInMainSection(isViewLoaded: true, loadedHotelInfo: self.hotelInDetailResult)
                } else {
                    self.adjustAmenitiesViewFrameToFit()
                }
                
                // insert deals view in
                self.menuContentsView.addSubview(self.amenitiesView!)
            })
        }
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
        lbGuest.text = searchInfo.numberOfGuest.toString()
        if (searchInfo.numberOfRooms == 1) {
            lbRoom.text = searchInfo.numberOfRooms.toString() + "room"
        } else {
            lbRoom.text = searchInfo.numberOfRooms.toString() + "rooms"
        }
    }
    
    func setupImagesInHeader() {
        imgPassenger.image = UIImage(fromHex: JetExFontHexCode.jetexPassengers.rawValue, withColor: UIColor.white)
        imgRightArrow.image = UIImage(fromHex: JetExFontHexCode.oneWay.rawValue, withColor: UIColor.white)
    }
    
    func setupHeroSection() {
        
        self.imageSlideShow.slideshowInterval = 10 // 3 seconds
        self.imageSlideShow.contentScaleMode = .scaleAspectFill // fill mode
        self.imageSlideShow.pageControlPosition = .hidden
       
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HotelDetailsVC.didTapTheImageInHero))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
        
        // bind initial data
        bindDataForHeroSection(isViewLoaded: false, initHotelInfo: self.pickedHotel, loadedHotelInfo: nil)
    }
    
    func didTapTheImageInHero() {
        let vc = imageSlideShow.presentFullScreenController(from: self)
//        let screnSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.0) {
            vc.closeButton.center = CGPoint(x: 24, y: 48)
        }
    }
    
    func setUpMainViewSection() {
        setUpMenuInMainViewSection()
        setUpMapViewInMainViewSection()
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
    
    func setUpMapViewInMainViewSection() {
        if let navigationController = self.navigationController {
            animationController = ZoomTransition(navigationController: navigationController)
        }
        self.navigationController?.delegate = animationController
    }
    
    //MARK: - Binding Data
    func bindDataForHeroSection(isViewLoaded: Bool, initHotelInfo: Hotel? = nil, loadedHotelInfo: HotelinDetailResult? = nil) {
        if isViewLoaded {
            // view loaded, use detail info
            var imagesInput : [AlamofireSource] = []
            
            for urlString in loadedHotelInfo!.hotels.first!.getImageUrlsList(withHost: loadedHotelInfo!.imageHostUrl) {
                imagesInput.append(AlamofireSource(urlString: urlString)!)
            }
            
            self.imageSlideShow.setImageInputs(imagesInput)
            self.imageSlideShow.slideshowInterval = 10.0
            
            //self.rateScoreInHeroLabel.text = loadedHotelInfo!.score
            self.rateScoreInHeroLabel.text = "\(Float(loadedHotelInfo!.hotels.first!.popularity) / 10.0)/10"
            self.rateDescriptionInHeroLabel.text = loadedHotelInfo!.hotels.first!.popularityDesc
            if let reviews = loadedHotelInfo?.hotelPrices.first?.reviews {
                self.rateCountInHeroLabel.text = "Based on \(reviews.count) reviews"
            }
            
            
        } else {
            // view is not done loading yet, use info from previous view
            // load image, stop sliding
            self.imageSlideShow.setImageInputs([AlamofireSource(urlString: initHotelInfo!.getImageUrl())!])
            self.imageSlideShow.slideshowInterval = 0.0
            
            self.rateScoreInHeroLabel.text = "\(Float(initHotelInfo!.popularity) / 10.0)/10"
            self.rateDescriptionInHeroLabel.text = initHotelInfo!.popularityDesc
            self.rateCountInHeroLabel.text = "Based on reviews"
        }
    }
    
    func bindDataForInfoSection(isViewLoaded: Bool, initHotelInfo: Hotel? = nil, loadedHotelInfo: HotelinDetail? = nil) {
        if isViewLoaded {
            // view loaded, use detail info
            var stars = ""
            for _ in 1...loadedHotelInfo!.star {
                stars += "★"
            }
            
            self.starsCountLabel.text = stars
            self.hotelNameLabel.text = loadedHotelInfo!.name
            self.hotelAddressLabel.text = loadedHotelInfo!.address
            self.hotelShortDescriptionLabel.text = loadedHotelInfo!.description
            
        } else {
            // view is not done loading yet, use info from previous view
            // load info
            var stars = ""
            for _ in 1...initHotelInfo!.star {
                stars += "★"
            }
            
            self.starsCountLabel.text = stars
            self.hotelNameLabel.text = initHotelInfo!.name
            self.hotelAddressLabel.text = initHotelInfo!.address
        }
    }
    
    func bindDataForReviewsInMainSection(isViewLoaded: Bool, loadedHotelInfo: HotelinDetailResult? = nil) {
        if isViewLoaded {
            // view loaded, use detail info
            self.reviewsView!.bindingData(score: loadedHotelInfo!.hotels.first!.popularity, summary: loadedHotelInfo!.hotels.first!.popularityDesc, reviews: loadedHotelInfo!.hotelPrices.first!.reviews!)
        } else {
            // view is not done loading yet, use info from previous view
        }
    }
    
    func bindDataForMapInMainSection(isViewLoaded: Bool, loadedHotelInfo: HotelinDetailResult? = nil) {
        if isViewLoaded {
            // view loaded, use detail info
            self.mapView?.bindingData(hotelInfo: loadedHotelInfo!.hotels.first!)
        } else {
            // view is not done loading yet, use info from previous view
        }
    }
    
    func bindDataForVouncherInMainSection(isViewLoaded: Bool, loadedHotelInfo: HotelinDetailResult? = nil) {
        if isViewLoaded {
            // view loaded, use detail info
            self.dealsView?.bindingData(hotelInfo: loadedHotelInfo!)
        } else {
            // view is not done loading yet, use info from previous view
        }
    }
    
    func bindDataForAmenitiesInMainSection(isViewLoaded: Bool, loadedHotelInfo: HotelinDetailResult? = nil) {
        if isViewLoaded {
            // view loaded, use detail info
            self.amenitiesView?.bindingData(hotelInfo: loadedHotelInfo!)
        } else {
            // view is not done loading yet, use info from previous view
        }
    }
}


extension HotelDetailsVC: HotelDetailsVCDelegate {
    func resizeContentViewInScrollViewWithNewComponentHeight(newComponentHeight: CGFloat, complete: (() -> Void)?){
        let newActualHeight = self.mainBasedViewHeight + newComponentHeight
        self.resizeMenuContentScrollView(newHeight: newActualHeight, complete: complete)
    }
    
    func adjustDealsViewFrameToFit() {
        UIView.animate(withDuration: 0.1) {
            self.dealsView?.frame = self.menuContentsView.bounds
            self.dealsView?.layoutIfNeeded()
        }
    }
    
    func adjustReviewsViewFrameToFit() {
        UIView.animate(withDuration: 0.1) {
            self.reviewsView?.frame = self.menuContentsView.bounds
            self.reviewsView?.layoutIfNeeded()
        }
    }
    
    func adjustAmenitiesViewFrameToFit() {
        UIView.animate(withDuration: 0.1) { 
            self.amenitiesView?.frame = self.menuContentsView.bounds
            self.amenitiesView?.layoutIfNeeded()
        }
    }
    
    func zoomMapToFullScreen() {
        let vc = MapFullScreenVC(nibName: "MapFullScreenVC", bundle: nil)
        vc.searchInfo = self.searchInfo
        vc.mapType = .hotelMap
        vc.hotel = self.pickedHotel
//        _ = self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - Database for Detail
extension HotelDetailsVC {
    func getHotelInfoInDetail() {
        let url = "\(APIURL.JetExAPI.base)\(APIURL.JetExAPI.getHotelDetailInfo)/\(pickedHotel.id)"
        
        Alamofire.request(url, method: .get, parameters: nil).responseJSON { (response) in
            if let data = response.result.value as? [String: Any] {
                self.hotelInDetailResult = HotelinDetailResult(JSON: data)!
                
                self.bindDataForHeroSection(isViewLoaded: true, initHotelInfo: nil, loadedHotelInfo: self.hotelInDetailResult)
                self.bindDataForInfoSection(isViewLoaded: true, initHotelInfo: nil, loadedHotelInfo: self.hotelInDetailResult?.hotels.first)
            }
        }

    }
}

extension HotelDetailsVC: ZoomTransitionProtocol, UINavigationControllerDelegate {
    func viewForTransition() -> UIView {
        return (mapView != nil ? mapView! : menuContentsView)
    }
}
