//
//  TagMO+CoreDataProperties.swift
//  TaskKit
//
//  Created by luobobo on 2022/6/20.
//
//

import Foundation
import CoreData


extension TagMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagMO> {
        return NSFetchRequest<TagMO>(entityName: "TagMO")
    }

    @NSManaged public var color: String?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}

extension TagMO : Identifiable {

}
