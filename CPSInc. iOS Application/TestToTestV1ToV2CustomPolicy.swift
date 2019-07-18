//
//  TestToTestV1ToV2CustomPolicy.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-17.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import Foundation
import CoreData

class TestToTestV1ToV2CustomPolicy: NSEntityMigrationPolicy{
    
    
    override public func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        
        //get model version being mapped to
        //let modelVersion = mapping.userInfo?["modelVersion"] as! Int
        
        //check that it is mapping to model version 2
        //if(modelVersion == 2){
            
            if(sInstance.entity.name == "Test"){
                //can save all these as strings (to transformable) because there are set rules on how to go from string to binary blob - there are no obvious rules to go from int16 to binary blob which is why you get the error in test
                let dInstance = NSEntityDescription.insertNewObject(forEntityName: "Test", into: manager.destinationContext) //insert new obejct into destination context
                dInstance.setValue(sInstance.primitiveValue(forKey: "dataType") as! String, forKey: "dataType")
                dInstance.setValue(sInstance.primitiveValue(forKey: "date") as! Date, forKey: "date")
                dInstance.setValue(sInstance.primitiveValue(forKey: "runtime") as! NSNumber, forKey: "runtime")
                dInstance.setValue(sInstance.primitiveValue(forKey: "testType") as! String, forKey: "testType")
                dInstance.setValue(sInstance.primitiveValue(forKey: "units") as! String, forKey: "units")
                dInstance.setValue(sInstance.primitiveValue(forKey: "value") as! Float, forKey: "value")
                

            }
        
    }
    
    
    override public func createRelationships(forDestination dInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        
        
    }
    
}
