//
//  AirlinesView.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

protocol AirlinesViewDelegate: class {
    func showAllAirlines()
    func hideAirlines()
    func didCheck(index: Int)
}

class AirlinesView: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    var arrayChecked = [Int]()
    var isShowAll = false
    weak var delegate: AirlinesViewDelegate?
    @IBOutlet weak var constraintTableHeight: NSLayoutConstraint!
    var carriers: [Carrier]?
    @IBOutlet weak var btnShowAll: UIButton!
    @IBOutlet weak var constraintBtnShowAllHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "AirlinesCell", bundle:nil), forCellReuseIdentifier: "AirlinesCell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }
    
    @IBAction func showAll(_ sender: UIButton) {
        isShowAll = !isShowAll
        
        if (isShowAll) {
            sender.setTitle("Hide", for: .normal)
            self.delegate?.showAllAirlines()

            constraintTableHeight.constant = CGFloat((carriers?.count)! * 44)
        } else {
            sender.setTitle("Show all 6 airlines", for: .normal)
            self.delegate?.hideAirlines()
            constraintTableHeight.constant = CGFloat(min((carriers?.count)!, 4) * 44)
        }
        
        self.tableView.reloadData()
    }
}

extension AirlinesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard carriers != nil else {
            return 0
        }
        
        if (!isShowAll) {
            return min((carriers?.count)!, 4)
        }
        return (carriers?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirlinesCell", for: indexPath) as! AirlinesCell
        
        if (arrayChecked.contains(indexPath.row)) {
            cell.btnCheck.image = UIImage(named: "check rect")
            cell.lbTitle.textColor = UIColor(hex: 0x674290)
        } else {
            cell.btnCheck.image = UIImage(named: "uncheck rect")
            cell.lbTitle.textColor = UIColor(hex: 0x515151)
        }
        
        cell.lbTitle.text = carriers?[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (arrayChecked.contains(indexPath.row)) {
            let index = arrayChecked.index(of: indexPath.row)
            arrayChecked.remove(at: index!)
        } else {
            arrayChecked.append(indexPath.row)
        }
        
        tableView.reloadData()
        
        delegate?.didCheck(index: indexPath.row)
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.01
//    }

}
