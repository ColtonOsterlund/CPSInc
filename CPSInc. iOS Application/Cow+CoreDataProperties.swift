//
//  Cow+CoreDataProperties.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-06-27.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//
//

import Foundation
import CoreData


extension Cow {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cow> {
        return NSFetchRequest<Cow>(entityName: "Cow")
    }

    @NSManaged public var daysInMilk: String?
    @NSManaged public var dryOffDay: String?
    @NSManaged public var id: String?
    @NSManaged public var mastitisHistory: String?
    @NSManaged public var methodOfDryOff: String?
    @NSManaged public var name: String?
    @NSManaged public var parity: String?
    @NSManaged public var reproductionStatus: String?
    @NSManaged public var herd: Herd?
    @NSManaged public var testData: NSSet?

}

// MARK: Generated accessors for testData
extension Cow {

    @objc(addTestDataObject:)
    @NSManaged public func addToTestData(_ value: Test)

    @objc(removeTestDataObject:)
    @NSManaged public func removeFromTestData(_ value: Test)

    @objc(addTestData:)
    @NSManaged public func addToTestData(_ values: NSSet)

    @objc(removeTestData:)
    @NSManaged public func removeFromTestData(_ values: NSSet)

}
