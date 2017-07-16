//
//  Lens.swift
//  LensCounter
//
//  Created by Brent Eerlingen on 2/07/17.
//  Copyright © 2017 Brent Eerlingen. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Lens: NSObject, NSCoding {
    //MARK: Properties
    var brand: String
    var type: String
    var counter: Int
    var isActivated: Bool
    var photo : UIImage?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("lenses")
    
    //MARK: Type
    struct PropertyKey {
        static let brand = "brand"
        static let type = "type"
        static let isActivated = "isActivated"
         static let photo = "photo"
    }
    
    
    //MARK: Initialitation
    init?(brand: String, type: String, isActivated: Bool, photo: UIImage?) {
        
        // The name must not be empty
        guard !brand.isEmpty else {
            return nil
        }
        
        guard !type.isEmpty else {
            return nil
        }
        
        self.brand = brand
        self.type = type
        
        self.photo = photo  
        
        switch type {
        case "Month":
            counter = 30
        case "Week":
            counter = 7
        default :
            counter = 0
        }
        
        self.isActivated = isActivated
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(brand, forKey: PropertyKey.brand)
        aCoder.encode(type, forKey: PropertyKey.type)
        aCoder.encode(isActivated, forKey: PropertyKey.isActivated)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let brand = aDecoder.decodeObject(forKey: PropertyKey.brand)
        
        let type = aDecoder.decodeObject(forKey: PropertyKey.type)
        
        let isActivated = aDecoder.decodeBool(forKey: PropertyKey.isActivated)
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        // Must call designated initializer.
        self.init(brand: brand as! String, type: type as! String,  isActivated: isActivated, photo: photo)
    }
}
