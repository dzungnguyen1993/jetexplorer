//
//  StopView.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class StopView: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    
    var arrayTitles = ["Non-stop", "Max. 1 stop", "Any stop"]
    var checkedIndex = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "StopCell", bundle:nil), forCellReuseIdentifier: "StopCell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension StopView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StopCell", for: indexPath) as! StopCell
 
        if (checkedIndex == indexPath.row) {
            cell.btnCheck.image = UIImage(named: "check round")
            cell.lbTitle.textColor = UIColor(hex: 0x674290)
        } else {
            cell.btnCheck.image = UIImage(named: "uncheck round")
            cell.lbTitle.textColor = UIColor(hex: 0x515151)
        }
        
        cell.lbTitle.text = arrayTitles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkedIndex = indexPath.row
        tableView.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.01
//    }
}
