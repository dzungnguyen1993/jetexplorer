//
//  DBManager.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/25/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager: NSObject {
    static let shared = DBManager()
    
    var realm : Realm!
    private override init() {
        
    }
    
    func parseListAirportJSON(data: NSDictionary) {
        realm = try! Realm()
        
        var continents = [Continent]()
        
        let continentsDict = data["Continents"] as! [NSDictionary]
        for continentDict in continentsDict {
            let continent = Continent()
            continent.name = continentDict["Name"] as! String
            continent.id = continentDict["Id"] as! String
            
            let countriesDict = continentDict["Countries"] as! [NSDictionary]
            
            continent.countries = self.parseListCountries(countriesDict: countriesDict)
            try! realm.write {
                realm.add(continent, update: true)
            }
            continents.append(continent)
        }
    }
    
    func parseListCountries(countriesDict: [NSDictionary]) -> List<Country> {
        let listCountries = List<Country>()
        
        for countryDict in countriesDict {
            let country = Country()
            country.id = countryDict["Id"] as! String
            country.name = countryDict["Name"] as! String
            
            let citiesDict = countryDict["Cities"] as! [NSDictionary]
            
            country.cities = self.parseListCities(citiesDict: citiesDict)
            try! realm.write {
                realm.add(country, update: true)
            }
            
            listCountries.append(country)
        }
        
        return listCountries
    }
    
    func parseListCities(citiesDict: [NSDictionary]) -> List<City> {
        let listCities = List<City>()
        
        for cityDict in citiesDict {
            let city = City()
            
            city.id = cityDict["Id"] as! String
            city.name = cityDict["Name"] as! String
            city.iataCode = cityDict["IataCode"] as! String
            city.countryId = cityDict["CountryId"] as! String
            city.location = cityDict["Location"] as! String
            
            let airportsDict = cityDict["Airports"] as! [NSDictionary]
            
            let singleAirportCity = cityDict["SingleAirportCity"] as! Bool
            let airportAll = Airport()
            
            if (!singleAirportCity) {
                airportAll.id = city.iataCode
                airportAll.name = city.name + " All Airports"
                airportAll.cityId = city.id
                airportAll.countryId = city.countryId
                
                try! realm.write {
                    realm.add(airportAll, update: true)
                }
            }
            
            city.airports = self.parseListAirports(airportsDict: airportsDict)
            
            if (!singleAirportCity) {
                city.airports.append(airportAll)
            }
            
            try! realm.write {
                realm.add(city, update: true)
            }
            
            listCities.append(city)
            
        }
        
        return listCities
    }
    
    func parseListAirports(airportsDict: [NSDictionary]) -> List<Airport> {
        let listAirports = List<Airport>()
        
        for airportDict in airportsDict {
            let airport = Airport()
            
            airport.id = airportDict["Id"] as! String
            airport.name = airportDict["Name"] as! String
            airport.cityId = airportDict["CityId"] as! String
            airport.countryId = airportDict["CountryId"] as! String
            
            try! realm.write {
                realm.add(airport, update: true)
            }
            listAirports.append(airport)
        }
        
        return listAirports
    }
    
    func getCity(withIataCode code: String) -> City? {
        realm = try! Realm()
        
        let predicate = NSPredicate(format: "iataCode == %@", code)
        let city = realm.objects(City.self).filter(predicate).first
        
        return city
    }
    
    func convertListAirportToArray(list: List<Airport>) -> [Airport] {
        var array = [Airport]()
        
        for i in 0..<list.count {
            let airport = list[i]
            if !airport.name.contains("All Airports") {
                array.append(airport)
            }
        }
        
        return array
    }
    
    func getCountry(fromCity city: City) -> Country? {
        realm = try! Realm()
        let countryId = city.countryId
        let predicate = NSPredicate(format: "id == %@", countryId)
        let country = realm.objects(Country.self).filter(predicate).first
        
        return country
    }
}
