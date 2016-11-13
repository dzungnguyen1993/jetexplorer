//
//  PickDateVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/12/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

public enum PickDateType {
    case Depart, Return
}

class PickDateVC: BaseViewController {

    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var viewDepart: PickInfoView!
    @IBOutlet weak var viewReturn: PickInfoView!
    var departDay, returnDay: Date?
    @IBOutlet weak var weekdayView: DateIndicatorView!
    var pickDateType: PickDateType!
    
    var calendarPickerVC: EPCalendarPicker!
    
    @IBOutlet weak var calendarStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 15)!], for: .normal)
        loadViewDepartReturn()
        addActionForViews()
        loadWeekdayIndicator(view: ((pickDateType == .Depart) ? viewDepart : viewReturn))
        loadCalendar()
    }
    
    func loadViewDepartReturn() {
        viewDepart.imgView.image = UIImage(named: "")
        viewDepart.lbTitle.text = "Depart"
        if (departDay != nil) {
            
        } else {
            viewDepart.lbInfo.text = ""
            viewDepart.lbSubInfo.text = ""
        }
        
        viewReturn.imgView.image = UIImage(named: "")
        viewReturn.lbTitle.text = "Return"
        if (returnDay != nil) {
            
        } else {
            viewReturn.lbInfo.text = ""
            viewReturn.lbSubInfo.text = ""
        }
    }
    
    func addActionForViews() {
        let tapViewDepart = UITapGestureRecognizer(target: self, action: #selector(pickDepartDay(sender:)))
        viewDepart.addGestureRecognizer(tapViewDepart)
        
        let tapViewReturn = UITapGestureRecognizer(target: self, action: #selector(pickReturnDay(sender:)))
        viewReturn.addGestureRecognizer(tapViewReturn)
    }
    
    func loadWeekdayIndicator(view: UIView) {
        weekdayView.xIndicator = view.center.x - 30
        weekdayView.setNeedsDisplay()
        self.view.bringSubview(toFront: weekdayView)
    }
    
    func loadCalendar() {
        calendarPickerVC = EPCalendarPicker(startDateOfCalendar: startDateOfCalendar, endDateOfCalendar: endDateOfCalendar, checkInDate: checkInDate, checkOutDate: checkOutDate, indicatorPosition: .CheckInStackView)
//        calendarPickerViewController.datePickerViewController = self
        addChildViewController(calendarPickerVC)
        calendarStackView.addArrangedSubview(calendarPickerVC.view)
        calendarPickerVC.didMove(toParentViewController: self)
    }
    
    var startDateOfCalendar: Date = {
        let date = Calendar.current.date(byAdding: Calendar.Component.day, value: 0, to: Date())!
        return Calendar.current.startOfDay(for: date)
    }()
    var endDateOfCalendar: Date = {
        let date = Calendar.current.date(byAdding: Calendar.Component.day, value: 330, to: Date())!
        return Calendar.current.startOfDay(for: date)
    }()
    
    var checkInDate: Date = {
        let date = Calendar.current.date(byAdding: Calendar.Component.day, value: 0, to: Date())!
        return Calendar.current.startOfDay(for: date)
    }()
    
    var checkOutDate: Date = {
        let date = Calendar.current.date(byAdding: Calendar.Component.day, value: 0, to: Date())!
        let startDate = Calendar.current.startOfDay(for: date)
        let d2 = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: startDate)!
        return Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: startDate)!
    }()
    
    // MARK: IBAction
    @IBAction func donePickDate(_ sender: UIBarButtonItem) {
        self.navigationController!.popViewController(animated: true)
    }
}

extension PickDateVC {
    func pickDepartDay(sender: UITapGestureRecognizer) {
        loadWeekdayIndicator(view: viewDepart)
    }
    
    func pickReturnDay(sender: UITapGestureRecognizer) {
        loadWeekdayIndicator(view: viewReturn)
    }
}

public enum IndicatorPosition {
    case CheckInStackView, CheckOutStackView
}
