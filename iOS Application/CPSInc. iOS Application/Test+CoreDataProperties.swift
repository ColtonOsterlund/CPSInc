//
//  Test+CoreDataProperties.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2020-07-21.
//  Copyright © 2020 Creative Protein Solutions Inc. All rights reserved.
//
//

import Foundation
import CoreData


extension Test {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Test> {
        return NSFetchRequest<Test>(entityName: "Test")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var followUpNum: NSNumber?
    @NSManaged public var testID: String?
    @NSManaged public var testType: String?
    @NSManaged public var units: String?
    @NSManaged public var value: Float
    @NSManaged public var milkFever: Bool
    @NSManaged public var cow: Cow?

}
