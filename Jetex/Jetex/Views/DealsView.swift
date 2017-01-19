//
//  DealsView.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/10/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class DealsView: UIView {

    static var height : CGFloat = 558.0
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var dealsTableView: UITableView!
    @IBOutlet weak var seeMoreView: UIView!
    @IBOutlet weak var seeMoreViewHeightConstraint: NSLayoutConstraint!
    
    //var dealsList: [String]! = ["1", "2", "3", "4", "5", "6", "7"]
    
    var hotelInfo: HotelinDetail?
    var dealsList: [(AgentPrice, HotelAgent)] = []
    var minimumElementsShouldBeShown = 3
    var delegate : HotelDetailsVCDelegate?
    
    func initView() {
        Bundle.main.loadNibNamed("DealsView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        
        setUpDealsTableView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    func bindingData(hotelInfo: HotelinDetailResult) {
        self.hotelInfo = hotelInfo.hotels.first
        dealsList = []
        for price in hotelInfo.hotelPrices.first!.agentPrices {
            // only show available-room deals
            if price.availableRooms > 0 {
                if let itsAgent = hotelInfo.findAgentForProvidedPrice(agentId: price.id) {
                    dealsList.append((price, itsAgent))
                }
            }
        }
        self.dealsTableView.reloadData()
        
        if dealsList.count <= 3 {
            // hide the see more button
            self.seeMoreViewHeightConstraint.constant = 0
            self.seeMoreView.alpha = 0
            self.seeMoreView.layoutIfNeeded()
            
            let newHeight = dealsList.count * (142 + 8) + 16 // 16 is space to bottom
            self.delegate?.resizeContentViewInScrollViewWithNewComponentHeight(newComponentHeight: CGFloat(newHeight)) {
                self.delegate?.adjustDealsViewFrameToFit()
            }
        }
    }

    @IBAction func viewMoreDealsButtonPressed(_ sender: Any) {
        // show all the elements
        minimumElementsShouldBeShown = dealsList.count
        dealsTableView.reloadData()
        
        // hide the see more button
        seeMoreViewHeightConstraint.constant = 0
        
        UIView.animate( withDuration: 0.5) { (completed) in
            self.seeMoreView.alpha = 0
            self.seeMoreView.layoutIfNeeded()
        }
        
        // let people scroll down
        self.dealsTableView.isScrollEnabled = true
        
        // calculate new height
        // =     self.dealsTableView.frame.size.height // (count * 8 + count * 142)
        //        + 16.0 // space at the bottom
        let newHeight = dealsList.count * (142 + 8) + 16
        self.delegate?.resizeContentViewInScrollViewWithNewComponentHeight(newComponentHeight: CGFloat(newHeight)) {
            self.delegate?.adjustDealsViewFrameToFit()
        }
    }
}

extension DealsView : UITableViewDelegate, UITableViewDataSource {
    
    func setUpDealsTableView () {
        // collection view
        
        self.dealsTableView.register(UINib(nibName: "DealTableViewCell", bundle: nil), forCellReuseIdentifier: "DealTableViewCell")
        
        self.dealsTableView.delegate = self
        self.dealsTableView.dataSource = self
        
        // first don't let people scroll
        self.dealsTableView.isScrollEnabled = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.minimumElementsShouldBeShown < dealsList.count ? self.minimumElementsShouldBeShown : dealsList.count)
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dealsTableView.dequeueReusableCell(withIdentifier: "DealTableViewCell", for: indexPath) as! DealTableViewCell
        
        cell.bindData(of: self.hotelInfo!, withPrice: self.dealsList[indexPath.row].0, fromAgent: self.dealsList[indexPath.row].1)
        
        return cell
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return dealsList.count
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    
}
