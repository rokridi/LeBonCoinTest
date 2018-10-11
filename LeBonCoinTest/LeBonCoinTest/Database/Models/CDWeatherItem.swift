//
//  CDWeatherItem+CoreDataProperties.swift
//  
//
//  Created by Mohamed Aymen Landolsi on 11/10/2018.
//
//

import Foundation
import CoreData

protocol DataBaseModelable {
    associatedtype Model: Storable

    var model: Model {get}
    static var entityName: String {get}
    func update(with model: Model)
    static func fetchAll(in context: NSManagedObjectContext) throws -> [Self]
    static func create(with model: Model, in context: NSManagedObjectContext) throws -> Self
}

@objc(CDWeatherItem)
final class CDWeatherItem: NSManagedObject {
    
    @NSManaged public var temperature: Double
    @NSManaged public var humidity: Double
    @NSManaged public var cape: Double
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWeatherItem> {
        return NSFetchRequest<CDWeatherItem>(entityName: "CDWeatherItem")
    }
}

extension CDWeatherItem: DataBaseModelable {
    
    typealias Model = WeatherItem
    
    var model: WeatherItem {
        return WeatherItem(temperature: temperature, humidity: humidity, cape: cape)
    }
    
    static var entityName: String {
        return "\(CDWeatherItem.self)"
    }
    
    func update(with model: WeatherItem) {
        temperature = model.temperature
        humidity = model.humidity
        cape = model.cape
    }
    
    static func fetchAll(in context: NSManagedObjectContext) throws -> [CDWeatherItem] {
        let fetchRequest = NSFetchRequest<CDWeatherItem>(entityName: "CDWeatherItem")
        return try fetchRequest.execute()
    }
    
    static func create(with model: WeatherItem, in context: NSManagedObjectContext) throws -> CDWeatherItem {
        let entityDescription = NSEntityDescription.entity(forEntityName: "CDWeatherItem", in: context)
        let item = CDWeatherItem(entity: entityDescription!, insertInto: context)
        item.update(with: model)
        return item
    }
}

