//
//  Device+CoreDataProperties.swift
//  myDevices
//
//  Created by Greg Heo on 2015-08-24.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Device {

    @NSManaged var deviceType: String
    @NSManaged var name: String
    @NSManaged var owner: Person?

}
