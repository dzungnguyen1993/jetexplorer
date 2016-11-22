//
//  FilterFlightView.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

protocol FilterFlightViewDelegate: class {
    func hideFilter()
}

class FilterFlightView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FilterFlightViewDelegate?
    var stopViewHeight = 180
    var airlinesViewHeight = 280
    var destinationViewHeight = 182
    var applyViewHeight = 60
    @IBOutlet weak var imgCancel: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        Bundle.main.loadNibNamed("FilterFlightView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("FilterFlightView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "StopView", bundle:nil), forCellReuseIdentifier: "StopView")
        tableView.register(UINib(nibName: "AirlinesView", bundle:nil), forCellReuseIdentifier: "AirlinesView")
        tableView.register(UINib(nibName: "DestinationView", bundle:nil), forCellReuseIdentifier: "DestinationView")
        tableView.register(UINib(nibName: "ApplyFilterView", bundle:nil), forCellReuseIdentifier: "ApplyFilterView")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        imgCancel.image = UIImage(fromHex: JetExFontHexCode.jetexCross.rawValue, withColor: UIColor(hex: 0x515151))
    }
  
    @IBAction func hideFilter(_ sender: UIButton) {
        delegate?.hideFilter()
    }
    

}

extension FilterFlightView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StopView", for: indexPath) as! StopView
            cell.tableView.reloadData()
            return cell
        }
        
        if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AirlinesView", for: indexPath) as! AirlinesView
            cell.tableView.reloadData()
            cell.delegate = self
            return cell
        }
        
        if (indexPath.row == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationView", for: indexPath) as! DestinationView
            return cell
        }
        
        if (indexPath.row == 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyFilterView", for: indexPath) as! ApplyFilterView
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row) {
        case 0: return CGFloat(stopViewHeight)
        case 1 : return CGFloat(airlinesViewHeight)
        case 2: return CGFloat(destinationViewHeight)
        default: return CGFloat(applyViewHeight)
        }
    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.01
//    }
    
}

extension FilterFlightView: AirlinesViewDelegate {
    func showAllAirlines() {
        airlinesViewHeight = airlinesViewHeight + 44*2
        self.tableView.reloadData()
    }
    
    func hideAirlines() {
        airlinesViewHeight = airlinesViewHeight - 44*2
        self.tableView.reloadData()
    }
}
