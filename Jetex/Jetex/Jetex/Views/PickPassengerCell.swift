//
//  PickPassengerCell.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/12/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

protocol PickPassengerDelegate: class {
    func subtract(type: Int)
    func add(type: Int)
}

class PickPassengerCell: UITableViewCell {

    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    var type: Int!
    weak var delegate: PickPassengerDelegate?
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // TODO: You can also use Interface builder to change these attributes.
        buttonView.layer.borderColor = UIColor(hex: 0x642790).cgColor
        buttonView.layer.borderWidth = 1.0
        buttonView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func subtract(_ sender: UIButton) {
        self.delegate?.subtract(type: type)
    }
    
    @IBAction func add(_ sender: UIButton) {
        self.delegate?.add(type: type)
    }
}
