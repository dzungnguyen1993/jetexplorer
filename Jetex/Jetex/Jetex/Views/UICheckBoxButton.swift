//
//  UICheckBoxButton.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/15/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

protocol UICheckBoxButtonDelegate: class {
    func checkboxPressed()
}

class UICheckBoxButton: UIView {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var checkBoxLabel: UILabel!
    
    var delegate: UICheckBoxButtonDelegate?
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
        
        checkBoxLabel.font = UIFont(name: "JetExplorer", size:44.0);
        checkBoxLabel.text = "\(NSString.init(utf8String: "\u{e906}")!)"
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(selfPressed(sender:)))
        view.addGestureRecognizer(tapView)
    }
    
    func selfPressed(sender : AnyObject){
        isChecked = !isChecked
        if isChecked {
            // change image
            checkBoxLabel.text = "\(NSString.init(utf8String: "\u{e907}")!)"
            //print("checked")
        } else {
            // change image
            checkBoxLabel.text = "\(NSString.init(utf8String: "\u{e906}")!)"
            //print("un checked")
        }
        delegate?.checkboxPressed()
    }
}
