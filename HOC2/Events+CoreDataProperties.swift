//
//  Events+CoreDataProperties.swift
//  HOC2
//
//  Created by Markim Shaw on 5/17/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Events {

    @NSManaged var title: String?
    @NSManaged var videoId: String?

}
