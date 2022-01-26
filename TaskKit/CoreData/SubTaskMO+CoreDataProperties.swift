//
//  SubTaskMO+CoreDataProperties.swift
//  TaskKit
//
//  Created by huluobo on 2022/1/26.
//
//

import Foundation
import CoreData


extension SubTaskMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubTaskMO> {
        return NSFetchRequest<SubTaskMO>(entityName: "SubTaskMO")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var isCompleted: Bool

}

extension SubTaskMO : Identifiable {

}
