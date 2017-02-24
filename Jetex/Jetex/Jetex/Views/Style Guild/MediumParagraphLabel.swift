//
//  MediumParagraphLabel.swift
//  JetEx
//
//  Created by Nguyen Van Cuong on 6/21/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

class MediumParagraphLabel: UILabel {
    
    override func awakeFromNib() {
        font = UIFont(name: GothamFontName.Book.rawValue, size: 14)
    }

}
