//
//  TaskMO+CoreDataProperties.swift
//  TaskKit
//
//  Created by huluobo on 2022/1/26.
//
//

import Foundation
import CoreData


extension TaskMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskMO> {
        return NSFetchRequest<TaskMO>(entityName: "TaskMO")
    }

    @NSManaged public var content: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var remind: Int16
    @NSManaged public var startDate: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var title: String?
    @NSManaged public var subTasks: NSOrderedSet?
    @NSManaged public var tag: TagMO?

}

// MARK: Generated accessors for subTasks
extension TaskMO {

    @objc(insertObject:inSubTasksAtIndex:)
    @NSManaged public func insertIntoSubTasks(_ value: SubTaskMO, at idx: Int)

    @objc(removeObjectFromSubTasksAtIndex:)
    @NSManaged public func removeFromSubTasks(at idx: Int)

    @objc(insertSubTasks:atIndexes:)
    @NSManaged public func insertIntoSubTasks(_ values: [SubTaskMO], at indexes: NSIndexSet)

    @objc(removeSubTasksAtIndexes:)
    @NSManaged public func removeFromSubTasks(at indexes: NSIndexSet)

    @objc(replaceObjectInSubTasksAtIndex:withObject:)
    @NSManaged public func replaceSubTasks(at idx: Int, with value: SubTaskMO)

    @objc(replaceSubTasksAtIndexes:withSubTasks:)
    @NSManaged public func replaceSubTasks(at indexes: NSIndexSet, with values: [SubTaskMO])

    @objc(addSubTasksObject:)
    @NSManaged public func addToSubTasks(_ value: SubTaskMO)

    @objc(removeSubTasksObject:)
    @NSManaged public func removeFromSubTasks(_ value: SubTaskMO)

    @objc(addSubTasks:)
    @NSManaged public func addToSubTasks(_ values: NSOrderedSet)

    @objc(removeSubTasks:)
    @NSManaged public func removeFromSubTasks(_ values: NSOrderedSet)

}

extension TaskMO : Identifiable {

}
