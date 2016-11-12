//
//  PickPassengerVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/12/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

protocol PickPassengerVCDelegate: class {
    func donePickPassenger(passengers: [Int])
}

class PickPassengerVC: BaseViewController {

    let listPassengerType = ["Adult", "Children", "Senior", "Infant", "Lap infant"]
    var passengers: [Int]!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: PickPassengerVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PickPassengerCell", bundle: nil), forCellReuseIdentifier: "PickPassengerCell")
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
    }
    
    @IBAction func donePickPassenger(_ sender: UIBarButtonItem) {
        self.delegate?.donePickPassenger(passengers: passengers)
        self.navigationController!.popViewController(animated: true)
    }
}

extension PickPassengerVC: UITableViewDataSource, UITableViewDelegate, PickPassengerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickPassengerCell", for: indexPath) as! PickPassengerCell
        
        cell.lbName.text = listPassengerType[indexPath.row]
        cell.lbNumber.text = String(passengers[indexPath.row])
        cell.type = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    // MARK: Delegate
    func subtract(type: Int) {
        if (passengers[type] == 0) {
            return
        }
        passengers[type] -= 1
        self.tableView.reloadData()
    }
    
    func add(type: Int) {
        passengers[type] += 1
        self.tableView.reloadData()
    }
}
