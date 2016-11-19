//
//  UICheckBoxButton.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/15/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class UICheckBoxButton: UIView {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    var isChecked : Bool = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let view: UIView = Bundle.main.loadNibNamed("UICheckBoxButton", owner: self, options: nil)!.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(selfPressed(sender:)))
        view.addGestureRecognizer(tapView)
    }
    
    func selfPressed(sender : AnyObject){
        isChecked = !isChecked
        if isChecked {
            // change image
            checkImage.image = UIImage(named: "search")
            print("checked")
        } else {
            // change image
            checkImage.image = UIImage(named: "cancel")
            print("un checked")
        }
    }
}
