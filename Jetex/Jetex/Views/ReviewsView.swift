//
//  ReviewsView.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/10/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class ReviewsView: UIView {

    static let height : CGFloat = 370.0
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    @IBOutlet weak var reviewsDescriptionLabel: UILabel!
    @IBOutlet weak var reviewScoreLabel: UILabel!
    
    @IBOutlet weak var reviewsTableView: UITableView!
    
    //mock data
    var reviewsList = [("Cleanliness", 10.0) ,
                       ("Dining", 9.0 ),
                       ("Facilities" , 9.5),
                       ("Location" , 7.0),
                       ("Rooms", 8.0),
                       ("Service" , 9.0)]
    
    func initView() {
        Bundle.main.loadNibNamed("ReviewsView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        
        self.setUpReviewsTableView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
}

extension ReviewsView : UITableViewDelegate, UITableViewDataSource {
    func setUpReviewsTableView () {
        
        self.reviewsTableView.register(UINib(nibName: "ReviewTableCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableCellTableViewCell")
        
        self.reviewsTableView.delegate = self
        self.reviewsTableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ReviewTableCellTableViewCell", for: indexPath) as! ReviewTableCellTableViewCell
        
        cell.reviewName = reviewsList[indexPath.row].0
        cell.reviewScore = Float(reviewsList[indexPath.row].1)
        
        return cell
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}
