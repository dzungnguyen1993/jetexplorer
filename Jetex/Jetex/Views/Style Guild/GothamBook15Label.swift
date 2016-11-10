//
//  GothamBook15Label.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/11/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

@IBDesignable class GothamBook15Label: UILabel {

    override func awakeFromNib() {
        editAppearance()
    }
    
    override func prepareForInterfaceBuilder() {
        editAppearance()
    }
    
    private func editAppearance(){
        font = UIFont(name: GothamFontName.Book.rawValue, size: 15)
        sizeToFit()
    }

}
