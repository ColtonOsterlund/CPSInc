//
//  HerdToHerdV1ToV2CustomPolicy.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-17.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import Foundation
import CoreData

class HerdToHerdV1ToV2CustomPolicy: NSEntityMigrationPolicy{
    
    override public func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        
        //get model version being mapped to
        //let modelVersion = mapping.userInfo?["modelVersion"] as! Int
        
        //check that it is mapping to model version 2
        //if(modelVersion == 2){
        
            if(sInstance.entity.name == "Herd"){
                //can save all these as strings (to transformable) because there are set rules on how to go from string to binary blob - there are no obvious rules to go from int16 to binary blob which is why you get the error in test
                let dInstance = NSEntityDescription.insertNewObject(forEntityName: "Herd", into: manager.destinationContext) //insert new obejct into destination context
                dInstance.setValue(sInstance.primitiveValue(forKey: "id") as! String, forKey: "id")
                dInstance.setValue(sInstance.primitiveValue(forKey: "location") as! String, forKey: "location")
                dInstance.setValue(sInstance.primitiveValue(forKey: "milkingSystem") as! String, forKey: "milkingSystem")
                dInstance.setValue(sInstance.primitiveValue(forKey: "pin") as! String, forKey: "pin")
                
                
            }
    }
    
    override public func createRelationships(forDestination dInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        
        
        
    }
    
    
}
