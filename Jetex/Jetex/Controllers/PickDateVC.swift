//
//  PickDateVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/12/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

public enum PickDateType {
    case roundtrip, oneway
}

protocol PickDateVCDelegate: class {
    func didFinishPickDate(checkInDate: Date?, checkOutDate: Date?)
}

class PickDateVC: BaseViewController {

    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var viewDepart: PickInfoView!
    @IBOutlet weak var viewReturn: PickInfoView!
    var checkInDate, checkOutDate: Date?
    @IBOutlet weak var dateIndicatorView: DateIndicatorView!
    @IBOutlet weak var weekdayView: UIView!
    var calendarPickerVC: EPCalendarPicker!
    @IBOutlet weak var calendarStackView: UIStackView!
    var type: PickDateType!
    
    var indicatorPosition: IndicatorPosition! {
        didSet {
            guard calendarPickerVC != nil else {return}
            calendarPickerVC.indicatorPosition = indicatorPosition
        }
    }
    weak var delegate: PickDateVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (type == .oneway) {
            viewReturn.isHidden = true
        }
        
        doneBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 15)!], for: .normal)
        addActionForViews()
        loadWeekdayIndicator(view: ((self.indicatorPosition == .checkIn) ? viewDepart : viewReturn))
        
        loadViewDates()
        loadCalendar()
    }
    
    func loadViewDates() {
        viewDepart.imgView.image = UIImage(named: "")
        viewDepart.lbTitle.text = "Depart"
        
        var dayString = checkInDate?.toMonthDay()
        var weekday = checkInDate?.toWeekDay()
        viewDepart.lbInfo.text = dayString
        viewDepart.lbSubInfo.text = weekday
        
        
        viewReturn.imgView.image = UIImage(named: "")
        viewReturn.lbTitle.text = "Return"
        
        dayString = checkOutDate?.toMonthDay()
        weekday = checkOutDate?.toWeekDay()
        viewReturn.lbInfo.text = dayString
        viewReturn.lbSubInfo.text = weekday
    }
    
    func addActionForViews() {
        let tapViewDepart = UITapGestureRecognizer(target: self, action: #selector(pickDepartDay(sender:)))
        viewDepart.addGestureRecognizer(tapViewDepart)
        
        let tapViewReturn = UITapGestureRecognizer(target: self, action: #selector(pickReturnDay(sender:)))
        viewReturn.addGestureRecognizer(tapViewReturn)
    }
    
    func loadWeekdayIndicator(view: UIView) {
        dateIndicatorView.xIndicator = view.center.x - view.frame.width * 0.1
        dateIndicatorView.setNeedsDisplay()
    }
    
    func loadCalendar() {
        calendarPickerVC = EPCalendarPicker(startDateOfCalendar: startDateOfCalendar, endDateOfCalendar: endDateOfCalendar, checkInDate: checkInDate!, checkOutDate: checkOutDate!, indicatorPosition: indicatorPosition)
        calendarPickerVC.delegate = self
        calendarPickerVC.type = self.type
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
    
//    var initialCheckInDate: Date = {
//        let date = Calendar.current.date(byAdding: Calendar.Component.day, value: 0, to: Date())!
//        return Calendar.current.startOfDay(for: date)
//    }()
//    
//    var initialCheckOutDate: Date = {
//        let date = Calendar.current.date(byAdding: Calendar.Component.day, value: 0, to: Date())!
//        let startDate = Calendar.current.startOfDay(for: date)
//        let d2 = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: startDate)!
//        return Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: startDate)!
//    }()
    
    // MARK: IBAction
    @IBAction func donePickDate(_ sender: UIBarButtonItem) {
        self.delegate?.didFinishPickDate(checkInDate: checkInDate, checkOutDate: checkOutDate)
        self.navigationController!.popViewController(animated: true)
    }
}

extension PickDateVC: EPCalendarPickDateDelegate {
    func pickDepartDay(sender: UITapGestureRecognizer) {
        loadWeekdayIndicator(view: viewDepart)
        indicatorPosition = IndicatorPosition.checkIn
    }
    
    func pickReturnDay(sender: UITapGestureRecognizer) {
        loadWeekdayIndicator(view: viewReturn)
        indicatorPosition = IndicatorPosition.checkOut
    }
    
    func didPickCheckinDate(date: Date) {
        checkInDate = date
        loadViewDates()
    }
    
    func didPickCheckoutDate(date: Date) {
        checkOutDate = date
        loadViewDates()
    }
}

public enum IndicatorPosition {
    case checkIn, checkOut
}
