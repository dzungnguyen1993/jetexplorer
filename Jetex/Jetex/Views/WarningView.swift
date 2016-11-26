//
//  WarningView.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/26/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class WarningView: UIView {
    
    @IBOutlet weak var WarningTextLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let view: UIView = Bundle.main.loadNibNamed("WarningView", owner: self, options: nil)!.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setWarningMessage(text: String) {
        WarningTextLabel.text = text
    }
}

class WarningForInput {
    var titleLabel : UILabel?
    var inputTextField: UITextField?
    var warningView : WarningView?
    
    init(setWarning: String, for inputTextField: UITextField, withTitle titleLabel: UILabel?) {
        self.titleLabel = titleLabel
        self.inputTextField = inputTextField
        
        var origin = inputTextField.frame.origin
        origin.y += (inputTextField.frame.size.height - 8)
        
        let width = inputTextField.frame.size.width * 0.8 // 80% width of input field
        let height : CGFloat = 34
        
        self.warningView = WarningView(frame: CGRect(origin: origin, size: CGSize(width: width, height: height)))
        
        self.warningView?.WarningTextLabel.text = setWarning
        self.inputTextField?.superview?.addSubview(self.warningView!)
        
        hideWarning(animated: false)
    }
    
    func hideWarning(animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: { 
                self.warningView?.alpha = 0.0
                self.inputTextField?.layer.borderColor = UIColor.init(hex: 0x999999).cgColor
                self.titleLabel?.textColor = UIColor.init(hex: 0x515151)
            })
        } else {
            self.warningView?.alpha = 0.0
            self.inputTextField?.layer.borderColor = UIColor.init(hex: 0x999999).cgColor
            self.titleLabel?.textColor = UIColor.init(hex: 0x515151)
        }
    }
    
    func showWarning(animated: Bool = true, autoHide: Bool = false, after second: Int = 0, completion: (() -> Void)? = nil) {
        
        func autoHideView() {
            if autoHide {
                let delayTime = DispatchTime.now() + .seconds(second)
                DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                    self.hideWarning(animated: true)
                    completion?()
                })
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: { 
                self.warningView?.alpha = 1.0
                self.inputTextField?.layer.borderColor = UIColor.init(hex: 0xE8615B).cgColor
                self.titleLabel?.textColor = UIColor.init(hex: 0xE8615B)
            }, completion: { (completed) in
                autoHideView()
            })
        } else {
            self.warningView?.alpha = 1.0
            self.inputTextField?.layer.borderColor = UIColor.init(hex: 0xE8615B).cgColor
            self.titleLabel?.textColor = UIColor.init(hex: 0xE8615B)
            autoHideView()
        }
        
    }
}
