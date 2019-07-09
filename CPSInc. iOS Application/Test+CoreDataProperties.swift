//
//  Test+CoreDataProperties.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-06-27.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//
//

import Foundation
import CoreData


extension Test {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Test> {
        return NSFetchRequest<Test>(entityName: "Test")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var dataType: String?
    @NSManaged public var runtime: Int16
    @NSManaged public var testType: String?
    @NSManaged public var units: String?
    @NSManaged public var value: Float
    @NSManaged public var cow: Cow?

}
