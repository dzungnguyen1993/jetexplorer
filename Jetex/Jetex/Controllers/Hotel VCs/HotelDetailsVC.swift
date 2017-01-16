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
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HotelDetailsVC: ZoomTransitionProtocol, UINavigationControllerDelegate {
    func viewForTransition() -> UIView {
        return (mapView != nil ? mapView! : menuContentsView)
    }
}
