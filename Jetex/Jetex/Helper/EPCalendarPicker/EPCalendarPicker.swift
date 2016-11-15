//
//  EPCalendarPicker.swift
//  EPCalendar
//
//  Created by Prabaharan Elangovan on 02/11/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol EPCalendarPickDateDelegate: class {
    func didPickCheckinDate(date: Date)
    func didPickCheckoutDate(date: Date)
}

public class EPCalendarPicker: UICollectionViewController, UICollectionViewDelegateFlowLayout {

//    weak var datePickerViewController : DatePickerViewController!
//    public var multiSelectEnabled: Bool
    public var showsTodaysButton: Bool = true
//    public var tintColor: UIColor
    
    public var dayDisabledTintColor: UIColor
    public var weekdayTintColor: UIColor
    public var weekendTintColor: UIColor
    public var todayTintColor: UIColor
    public var dateSelectionColor: UIColor
    public var monthTitleColor: UIColor
    
    // new options
    public var hightlightsToday: Bool = true
    public var hideDaysFromOtherMonth: Bool = false
    public var barTintColor: UIColor
    
    public var backgroundImage: UIImage?
    public var backgroundColor: UIColor?
    
    private(set) public var checkInIndexPath: IndexPath!
    private(set) public var checkOutIndexPath: IndexPath!
    private(set) public var checkInDate: Date{
        didSet{
            self.delegate?.didPickCheckinDate(date: checkInDate)
        }
    }
    private(set) public var checkInDateComponents: DateComponents
    private(set) public var checkOutDate: Date{
        didSet{
            self.delegate?.didPickCheckoutDate(date: checkOutDate)
        }
    }
    private(set) public var checkOutDateComponents: DateComponents
    private(set) public var startDateCalendar: Date
    private(set) public var endDateCalendar: Date
    private(set) public var startDateCalendarComponents: DateComponents
    private(set) public var endDateCalendarComponents: DateComponents
    var focusDate: NSDate!{
        didSet{
            
        }
    }
    var indicatorPosition: IndicatorPosition!
    
    let calendar = Calendar.current
    var monthsBetweenStartAndEndDate: [Int] = []
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter
    }()
    var heightConstrain: NSLayoutConstraint!
    weak var delegate: EPCalendarPickDateDelegate?
    var type: PickDateType!
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // setup collectionview
        self.collectionView?.delegate = self
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "EPCalendarCell1", bundle: Bundle(for: EPCalendarPicker.self )), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UINib(nibName: "EPCalendarHeaderView", bundle: Bundle(for: EPCalendarPicker.self )), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        view.translatesAutoresizingMaskIntoConstraints = false
        heightConstrain = view.heightAnchor.constraint(equalToConstant: collectionView!.collectionViewLayout.collectionViewContentSize.height)
        heightConstrain.isActive = true

    }

    public override func viewDidLayoutSubviews() {
        heightConstrain.constant = collectionView!.collectionViewLayout.collectionViewContentSize.height
//        let layout = collectionView!.collectionViewLayout
//        let flowLayout = layout as! UICollectionViewFlowLayout
//        flowLayout.minimumInteritemSpacing = (view.frame.width - 20 * 2 - 30 * 7) / 6
    }
    
    
    
    public init(startDateOfCalendar: Date, endDateOfCalendar: Date, checkInDate: Date, checkOutDate: Date, indicatorPosition: IndicatorPosition!) {
        
        self.startDateCalendar = startDateOfCalendar
        self.endDateCalendar = endDateOfCalendar
        startDateCalendarComponents = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: startDateOfCalendar)
        endDateCalendarComponents = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: endDateOfCalendar)
        self.checkInDate = checkInDate
        checkInDateComponents = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: checkInDate)
        self.checkOutDate = checkOutDate
        checkOutDateComponents = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: checkOutDate)
        self.indicatorPosition = indicatorPosition
//        multiSelectEnabled = multiSelection
        
        
        //Text color initializations
//        tintColor = EPDefaults.tintColor
        self.barTintColor = EPDefaults.barTintColor
        self.dayDisabledTintColor = EPDefaults.dayDisabledTintColor
        self.weekdayTintColor = EPDefaults.weekdayTintColor
        self.weekendTintColor = EPDefaults.weekendTintColor
        self.dateSelectionColor = EPDefaults.dateSelectionColor
        self.monthTitleColor = EPDefaults.monthTitleColor
        self.todayTintColor = EPDefaults.todayTintColor

        //Layout creation
        let layout = UICollectionViewFlowLayout()
//        layout.sectionHeadersPinToVisibleBounds = true  // If you want make a floating header enable this property(Avaialble after iOS9)
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: 100,height: 44)
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20)
        super.init(collectionViewLayout: layout)
        
        findMonthsBetweenStartAndEndDate()
    }
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func findMonthsBetweenStartAndEndDate(){
        if endDateCalendarComponents.month! >= startDateCalendarComponents.month!{
            for month in startDateCalendarComponents.month!...endDateCalendarComponents.month! {
                monthsBetweenStartAndEndDate.append(month)
            }
        }
        else{
            for month in startDateCalendarComponents.month!...12{
                monthsBetweenStartAndEndDate.append(month)
            }
            for month in 1...endDateCalendarComponents.month!{
                monthsBetweenStartAndEndDate.append(month)
            }
        }
    }

    // MARK: UICollectionViewDataSource

    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return monthsBetweenStartAndEndDate.count
    }

    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        first date component of month
        var firstDateComponents = DateComponents()
        firstDateComponents.year = startDateCalendarComponents.year
        firstDateComponents.month = startDateCalendarComponents.month! + section
//        first date of month
        let firstDate = calendar.date(from: firstDateComponents)!
        
        let numberDayInMonth = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: firstDate)?.count
        var lastDate = calendar.date(byAdding: Calendar.Component.month, value: 1, to: firstDate)
        lastDate = calendar.date(byAdding: Calendar.Component.day, value: -1, to: lastDate!)
        return numberDayInMonth! + (calendar.component(Calendar.Component.weekday, from: firstDate) - 1) + (7 - calendar.component(Calendar.Component.weekday, from: lastDate!))
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> (UICollectionViewCell) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EPCalendarCell1
        
        var firstDateComponents = DateComponents()
        firstDateComponents.year = startDateCalendarComponents.year
        firstDateComponents.month = startDateCalendarComponents.month! + indexPath.section
//        first date of month
        let firstDate = calendar.date(from: firstDateComponents)!
        var lastDate = calendar.date(byAdding: Calendar.Component.month, value: 1, to: firstDate)!
        
//        last date of mon
        lastDate = calendar.date(byAdding: Calendar.Component.day, value: -1, to: lastDate)!
//        number of day in month1
        let prefixDayInMonth = (calendar.component(Calendar.Component.weekday, from: firstDate) - 1)
        let numberDayInMonth = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: firstDate)?.count
        
        guard indexPath.row + 1 >= calendar.component(Calendar.Component.weekday, from: firstDate) else { return cell }
        guard indexPath.row + 1 <= prefixDayInMonth + numberDayInMonth! else { return cell }
        
        
        var currentDateComponents = DateComponents()
        currentDateComponents.year = firstDateComponents.year
        currentDateComponents.month = firstDateComponents.month
        currentDateComponents.day =  indexPath.row + 1 - prefixDayInMonth
        let currentDate = calendar.date(from: currentDateComponents)!
        cell.currentDate = currentDate
        cell.currentDateComponents = currentDateComponents
        cell.lblDay.text = "\(currentDate.day())"
        cell.deselectedForLabel()
        cell.visibleForLabel()
        
//        visible những ngày trước startDateCalendar
        if currentDate.compare(startDateCalendar) == .orderedAscending{
            cell.disableForLabel()
            return cell
        }
        
        if (indexPath.row == 16 && indexPath.section == 0) {
            
        }
        
        if (type == .oneway) {
            if currentDate.compare(checkInDate) == .orderedSame{
                checkInIndexPath = indexPath
                cell.selectedForLabelColor()
            }
        } else {
            if currentDate.compare(checkInDate) == .orderedSame{
                checkInIndexPath = indexPath
                cell.selectedForLabelColor()
                if checkInDate.compare(checkOutDate) != .orderedSame{
                    cell.dateCellStyle = .CheckInDate
                }
            }
            if currentDate.compare(checkOutDate) == .orderedSame{
                checkOutIndexPath = indexPath
                cell.selectedForLabelColor()
                if checkInDate.compare(checkOutDate) != .orderedSame{
                    cell.dateCellStyle = .CheckOutDate
                }
            }
            if currentDate.compare(checkInDate) == .orderedDescending && currentDate.compare(checkOutDate) == .orderedAscending{
                cell.dateCellStyle = .DateBetweenCheckInAndOutDate
            }
        }

        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? EPCalendarCell1 else {return}
        cell.currentDate = nil
        cell.currentDateComponents = nil
        cell.lblDay.text = ""
        cell.deselectedForLabel()
        cell.visibleForLabel()
    }
    
     public override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indicatorPosition == IndicatorPosition.checkIn{
            guard let cell = collectionView.cellForItem(at: indexPath) as? EPCalendarCell1 else {return false}
            guard let currentDate = cell.currentDate else {return false}
            if currentDate.compare(startDateCalendar) == .orderedAscending{
                return false
            }
            if currentDate.compare(checkOutDate) != .orderedDescending || self.type == .oneway{
                return true
            }
            return false
        }
        if indicatorPosition == IndicatorPosition.checkOut{
            guard let cell = collectionView.cellForItem(at: indexPath) as? EPCalendarCell1 else {return false}
            guard let currentDate = cell.currentDate else {return false}
            if currentDate.compare(checkInDate) != .orderedAscending{
                return true
            }
            return false
        }
        return false
    }
    

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 20 * 2) / 7
        return CGSize(width: width, height: 30)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(20, 20, 20, 20) //top,left,bottom,right
    }
    
    public override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! EPCalendarHeaderView
            
            var firstDateComponents = DateComponents()
            firstDateComponents.year = startDateCalendarComponents.year!
            firstDateComponents.month = startDateCalendarComponents.month! + indexPath.section
            let firstDate = calendar.date(from: firstDateComponents)!
            
            header.lblTitle.text = firstDate.monthNameFull()
            header.lblTitle.textColor = monthTitleColor
            header.backgroundColor = UIColor.clear
            
            return header
        }

        return UICollectionReusableView()
    }

    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! EPCalendarCell1
        guard let indicatorPosition = indicatorPosition else {return}
        if indicatorPosition == .checkIn &&
            (indexPath.section != checkInIndexPath.section ||
            indexPath.row != checkInIndexPath.row){
            checkInDate = cell.currentDate
            checkInDateComponents = cell.currentDateComponents
//            let previousIndexpath = NSIndexPath(forItem: checkInIndexPath.item, inSection: checkInIndexPath.section)
//            collectionView.reloadItemsAtIndexPaths([previousIndexpath, indexPath])
            collectionView.reloadData()
            checkInIndexPath = indexPath as IndexPath!
        }
        if indicatorPosition == .checkOut &&
            (indexPath.section != checkOutIndexPath.section ||
            indexPath.row != checkOutIndexPath.row){
            checkOutDate = cell.currentDate
            checkOutDateComponents = cell.currentDateComponents
//            let previousIndexpath = NSIndexPath(forItem: checkOutIndexPath.item, inSection: checkOutIndexPath.section)
//            collectionView.reloadItemsAtIndexPaths([previousIndexpath, indexPath])
            collectionView.reloadData()
            checkOutIndexPath = indexPath
        }
    }
    
    //MARK: Button Actions
    
    internal func onTouchCancelButton() {
        
    }
    
    internal func onTouchDoneButton() {
    }

    internal func onTouchTodayButton() {
        scrollToToday()
    }
    
    
    public func scrollToToday () {
        let today = Date()
        scrollToMonthForDate(date: today)
    }
    
    public func scrollToMonthForDate (date: Date) {

        let month = date.month()
        let year = date.year()
        let section = ((year - startDateCalendarComponents.year!) * 12) + month
        let indexPath = IndexPath(row:1, section: section-1)
        
        self.collectionView?.scrollToIndexpathByShowingHeader(indexPath: indexPath as NSIndexPath)
    }
    
    
}
