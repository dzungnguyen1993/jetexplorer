//
//  AppDelegate.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/8/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import RealmSwift
import Realm
import PopupDialog
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // for Google login
        GIDSignIn.sharedInstance().clientID = APIURL.GoogleAPI.clientID
        
        // for Google Map
        GMSServices.provideAPIKey(APIURL.GoogleAPI.mapKey)
        
        UITabBar.appearance().tintColor = UIColor(hex: 0x674290)
        
        // set up pop up appearance
        let dialogAppearance = PopupDialogDefaultView.appearance()
        
        dialogAppearance.backgroundColor      = UIColor.white
        dialogAppearance.titleFont            = UIFont(name: GothamFontName.Bold.rawValue, size: 15.0)!
        dialogAppearance.titleColor           = UIColor(white: 0.4, alpha: 1)
        dialogAppearance.titleTextAlignment   = .center
        dialogAppearance.messageFont          = UIFont(name: GothamFontName.Book.rawValue, size: 15.0)!
        dialogAppearance.messageColor         = UIColor(white: 0.6, alpha: 1)
        dialogAppearance.messageTextAlignment = .center
        dialogAppearance.cornerRadius         = 4
        
        let buttonAppearance = DefaultButton.appearance()
        
        // Default button
        buttonAppearance.titleFont      = UIFont(name: GothamFontName.Bold.rawValue, size: 15.0)
        buttonAppearance.titleColor     = UIColor(hex: 0x674290)
        buttonAppearance.buttonColor    = UIColor.clear
        buttonAppearance.separatorColor = UIColor(hex: 0xD6D6D6)
        
        // Below, only the differences are highlighted
        
        // Cancel button
        CancelButton.appearance().titleFont       = UIFont(name: GothamFontName.Book.rawValue, size: 15.0)
        CancelButton.appearance().titleColor      = UIColor(hex: 0x999999)
        
        // Destructive button
        DestructiveButton.appearance().titleFont  = UIFont(name: GothamFontName.Book.rawValue, size: 15.0)
        DestructiveButton.appearance().titleColor = UIColor(hex: 0xE8615B)
        
        // for Facebook login
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.contains("facebook") {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        } else {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// parse json
extension AppDelegate {
//    func parseListAirportJSON(data: NSDictionary) {
//        realm = try! Realm()
//        
//        var continents = [Continent]()
//        
//        let continentsDict = data["Continents"] as! [NSDictionary]
//        for continentDict in continentsDict {
//            let continent = Continent()
//            continent.name = continentDict["Name"] as! String
//            continent.id = continentDict["Id"] as! String
//            
//            let countriesDict = continentDict["Countries"] as! [NSDictionary]
//            
//            continent.countries = self.parseListCountries(countriesDict: countriesDict)
//            try! realm.write {
//                realm.add(continent, update: true)
//            }
//            continents.append(continent)
//        }
//    }
//    
//    func parseListCountries(countriesDict: [NSDictionary]) -> List<Country> {
//        let listCountries = List<Country>()
//        
//        for countryDict in countriesDict {
//            let country = Country()
//            country.id = countryDict["Id"] as! String
//            country.name = countryDict["Name"] as! String
//            
//            let citiesDict = countryDict["Cities"] as! [NSDictionary]
//            
//            country.cities = self.parseListCities(citiesDict: citiesDict)
//            try! realm.write {
//                realm.add(country, update: true)
//            }
//            
//            listCountries.append(country)
//        }
//        
//        return listCountries
//    }
//    
//    func parseListCities(citiesDict: [NSDictionary]) -> List<City> {
//        let listCities = List<City>()
//        
//        for cityDict in citiesDict {
//            let city = City()
//            
//            city.id = cityDict["Id"] as! String
//            city.name = cityDict["Name"] as! String
//            
//            let airportsDict = cityDict["Airports"] as! [NSDictionary]
//            
//            city.airports = self.parseListAirports(airportsDict: airportsDict)
//            try! realm.write {
//                realm.add(city, update: true)
//            }
//            
//            listCities.append(city)
//            
//        }
//        
//        return listCities
//    }
//    
//    func parseListAirports(airportsDict: [NSDictionary]) -> List<Airport> {
//        let listAirports = List<Airport>()
//        
//        for airportDict in airportsDict {
//            let airport = Airport()
//            
//            airport.id = airportDict["Id"] as! String
//            airport.name = airportDict["Name"] as! String
//            airport.cityId = airportDict["CityId"] as! String
//            airport.countryId = airportDict["CountryId"] as! String
//            try! realm.write {
//                realm.add(airport, update: true)
//            }
//            listAirports.append(airport)
//        }
//        
//        return listAirports
//    }
}

