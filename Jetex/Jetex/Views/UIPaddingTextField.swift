//
//  UIPaddingTextField.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/15/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

@IBDesignable
class UIPaddingTextField: UITextField {

    @IBInspectable
    var paddingLeft : CGFloat = 12.0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.textRect(forBounds: bounds)
        textRect.origin.x += paddingLeft
        textRect.size.width -= paddingLeft
        return textRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.editingRect(forBounds: bounds)
        textRect.origin.x += paddingLeft
        textRect.size.width -= paddingLeft
        return textRect
    }

}
