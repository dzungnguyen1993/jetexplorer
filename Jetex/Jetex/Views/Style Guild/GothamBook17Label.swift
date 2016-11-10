//
//  GothamBook17Label.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/11/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

@IBDesignable class GothamBook17Label: UILabel {

    override func awakeFromNib() {
        editAppearance()
    }
    
    override func prepareForInterfaceBuilder() {
        editAppearance()
    }
    
    private func editAppearance(){
        font = UIFont(name: GothamFontName.Book.rawValue, size: 17)
        sizeToFit()
    }
}
