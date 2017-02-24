//
//  SmallParagraphButton.swift
//  JetEx
//
//  Created by Nguyen Van Cuong on 6/2/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

@IBDesignable class SmallParagraphButton: UIButton {

    override func awakeFromNib() {
        editAppearance()
    }
    
    override func prepareForInterfaceBuilder() {
        editAppearance()
    }
    
    private func editAppearance(){
        backgroundColor = UIColor(hex: 0x47C695)
        titleLabel?.font = UIFont(name: GothamFontName.Book.rawValue, size: 15)
    }
    
}
