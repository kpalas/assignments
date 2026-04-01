//
//  Contact+CoreDataProperties.swift
//  Core Data Example
//
//  Created by Kian Palas on 29/11/2025.
//
//

public import Foundation
public import CoreData


public typealias ContactCoreDataPropertiesSet = NSSet

extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?

}

extension Contact : Identifiable {

}
