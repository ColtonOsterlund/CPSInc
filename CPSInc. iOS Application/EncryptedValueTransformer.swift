//
//  EncryptedStringTransformer.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-07-12.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import Foundation
import UIKit
import RNCryptor

@objc(EncryptedValueTransformer) //either need this or to reference the project module with dot notaiton when specifying the value transformer for the Transformable attributes in the data model
public class EncryptedValueTransformer : ValueTransformer {
    let password = "S@ndeepHere123"

    override public func transformedValue(_ value: Any?) -> Any? {
        guard let passedValue = value else {
            return nil
        }

        let data = (passedValue as AnyObject).data(using: 4) //NSUTF8StringEncoding = 4 from Apple documentation
        let ciphertext = RNCryptor.encrypt(data: data!, withPassword: password)
        
        return ciphertext
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard value != nil else {
            return nil
        }
        do {
            let originalData = try RNCryptor.decrypt(data: (value as? NSData)! as Data, withPassword: password)
            return NSString(data: originalData, encoding: 4) //NSUTF8StringEncoding = 4 from Apple
            // ...
        } catch {
            print(error)
            return nil
        }
    }
}
