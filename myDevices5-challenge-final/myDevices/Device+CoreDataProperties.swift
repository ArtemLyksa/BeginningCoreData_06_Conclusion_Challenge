//
//  Device+CoreDataProperties.swift
//  myDevices
//
//  Created by Artem on 5/7/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Device {

    @NSManaged var deviceType: String
    @NSManaged var name: String
    @NSManaged var purchaseData: NSDate?
    @NSManaged var deviceID: String?
    @NSManaged var owner: Person?

}
