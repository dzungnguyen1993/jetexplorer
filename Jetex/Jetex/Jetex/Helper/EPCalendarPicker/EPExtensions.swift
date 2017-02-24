//
//  EPExtensions.swift
//  EPCalendar
//
//  Created by Prabaharan Elangovan on 29/11/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import Foundation
import UIKit

//MARK: UIViewController Extensions

extension UIViewController {
    
    func showAlert(message: String) {
        showAlert(message: message, andTitle: "")
    }
    
    func showAlert(message: String, andTitle title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: UICollectionView Extension
extension UICollectionView {
    
    func scrollToIndexpathByShowingHeader(indexPath: NSIndexPath) {
        let sections = self.numberOfSections
        
        if indexPath.section <= sections{
            let attributes = self.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader, at: indexPath as IndexPath)
            let topOfHeader = CGPoint(x: 0, y: attributes!.frame.origin.y - self.contentInset.top)
            self.setContentOffset(topOfHeader, animated:false)
        }
    }
}

//MARK: NSDate Extensions

extension Date {
    
    func sharedCalendar(){
        
    }
    
    func firstDayOfMonth () -> Date {
        let calendar = Calendar.current
        var dateComponent = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: self)
        
        dateComponent.day = 1
        return calendar.date(from: dateComponent)!
    }
    
    init(year : Int, month : Int, day : Int) {
        
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.year = year
        dateComponent.month = month
        dateComponent.day = day
        self.init(timeInterval:0, since:calendar.date(from: dateComponent)!)
    }
    
    func dateByAddingMonths(months : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.month = months
//        return calendar.dateByAddingComponents(dateComponent, toDate: self, options: NSCalendarOptions.MatchNextTime)!
        return calendar.date(byAdding: dateComponent, to: self)!
    }
    
    func dateByAddingDays(days : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.day = days
//        return calendar.dateByAddingComponents(dateComponent, toDate: self, options: NSCalendarOptions.MatchNextTime)!
        return calendar.date(byAdding: dateComponent, to: self)!
    }
    
    func hour() -> Int {
        let calendar = Calendar.current
        return calendar.component(Calendar.Component.hour, from: self)
    }
    
    func second() -> Int {
        let calendar = Calendar.current
        return calendar.component(Calendar.Component.second, from: self)
    }
    
    func minute() -> Int {
        let calendar = Calendar.current
        return calendar.component(Calendar.Component.minute, from: self)
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        return calendar.component(Calendar.Component.day, from: self)
    }
    
    func weekday() -> Int {
        let calendar = Calendar.current
        return calendar.component(Calendar.Component.weekday, from: self)
    }
    
    func month() -> Int {
        let calendar = Calendar.current
        return calendar.component(Calendar.Component.month, from: self)
    }
    
    func year() -> Int {
        let calendar = Calendar.current
        return calendar.component(Calendar.Component.year, from: self)
    }
    
    func numberOfDaysInMonth() -> Int {
        let calendar = Calendar.current
        let days = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self)
        return (days?.count)!
    }
    
    func dateByIgnoringTime() -> Date {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: self)
        return calendar.date(from: dateComponent)!
    }
    
    func monthNameFull() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.string(from: self)
    }
    
    func isSunday() -> Bool
    {
        return (self.getWeekday() == 1)
    }
    
    func isMonday() -> Bool
    {
        return (self.getWeekday() == 2)
    }
    
    func isTuesday() -> Bool
    {
        return (self.getWeekday() == 3)
    }
    
    func isWednesday() -> Bool
    {
        return (self.getWeekday() == 4)
    }
    
    func isThursday() -> Bool
    {
        return (self.getWeekday() == 5)
    }
    
    func isFriday() -> Bool
    {
        return (self.getWeekday() == 6)
    }
    
    func isSaturday() -> Bool
    {
        return (self.getWeekday() == 7)
    }
    
    func getWeekday() -> Int {
        let calendar = Calendar.current
        return calendar.component(Calendar.Component.weekday, from: self)
    }
    
    func isToday() -> Bool {
        return self.isDateSameDay(date: Date())
    }
    
    func isDateSameDay(date: Date) -> Bool {
         return (self.day() == date.day()) && (self.month() == date.month() && (self.year() == date.year()))

    }
}

func ==(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedSame
}

func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedAscending
}

func >(lhs: Date, rhs: Date) -> Bool {
    return rhs.compare(lhs) == ComparisonResult.orderedAscending
}
