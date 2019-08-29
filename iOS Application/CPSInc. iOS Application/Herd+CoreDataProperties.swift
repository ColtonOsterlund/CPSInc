//
//  Herd+CoreDataProperties.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-17.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//
//

//CLASS FOR HERD OBJECT

import Foundation
import CoreData


extension Herd {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Herd> {
        return NSFetchRequest<Herd>(entityName: "Herd")
    }

    @NSManaged public var id: String?
    @NSManaged public var location: String?
    @NSManaged public var milkingSystem: String?
    @NSManaged public var pin: String?
    @NSManaged public var cow: NSSet?

}

// MARK: Generated accessors for cow
extension Herd {

    @objc(addCowObject:)
    @NSManaged public func addToCow(_ value: Cow)

    @objc(removeCowObject:)
    @NSManaged public func removeFromCow(_ value: Cow)

    @objc(addCow:)
    @NSManaged public func addToCow(_ values: NSSet)

    @objc(removeCow:)
    @NSManaged public func removeFromCow(_ values: NSSet)

}
