//
//  H2Label.swift
//  JetEx
//
//  Created by Nguyen Van Cuong on 6/2/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

@IBDesignable class H2Label: UILabel {
    
    override func awakeFromNib() {
        editAppearance()
    }
    
    override func prepareForInterfaceBuilder() {
        editAppearance()
    }

    private func editAppearance(){
        font = UIFont(name: GothamFontName.Bold.rawValue, size: 18)
        sizeToFit()
    }
}
