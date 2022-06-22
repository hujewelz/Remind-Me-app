//
//  Task.swift
//  TaskKit
//
//  Created by huluobo on 2022/1/26.
//

import Foundation

public struct TKTask: Codable, Identifiable {
    public var id: UUID
    public var title: String
    public var createAt: Date
    public var isCompleted: Bool
    public var remind: Remind?
    public var `repeat`: Repeat?
    public var startAt: Date
    public var endAt: Date
    public var content: String
    public var subTasks: [SubTask] = []
    public var tag: Tag?
    
    public var isRemind: Bool { remind != nil}
    
    public enum Remind: Codable {
        case atTime
        case custom(Int)
        
        public init?(minutes: Int) {
            guard minutes >= 0 else { return nil }
            if minutes == 0 {
                self = .atTime
            } else {
                self = .custom(minutes)
            }
        }
        
        public var title: String {
            switch self {
            case .atTime:
                return "At time of task"
            case .custom(let minutes):
                if minutes < 60 {
                    return "\(minutes) minutes before"
                } else {
                    let hour = minutes / 60
                    return "\(hour) \(hour > 1 ? "hours" : "hour") before"
                }
                
            }
        }
        
        public var minutes: Int {
            switch self {
            case .atTime:
                return 0
            case .custom(let int):
                return int
            }
        }
    }
    
    public enum Repeat: Codable, CaseIterable {
        case day
        case week
        case month
        case year
    }
}

public struct SubTask: Codable, Identifiable {
    public var id: UUID
    public var title: String
    public var isCompleted: Bool
}

extension SubTask {
    public init() {
        self.init(id: UUID(), title: "", isCompleted: false)
    }
}

extension TKTask {
    public init(title: String) {
        id = UUID()
        self.title = title
        createAt = Date()
        isCompleted = false
        remind = nil
        `repeat` = nil
        startAt = Date()
        endAt = Date().advanced(by: 3600)
        content = ""
    }
    
    public mutating func addSubTask(_ subTask: SubTask) {
        subTasks.append(subTask)
    }
    
    public mutating func removeSubTask(_ subTask: SubTask) {
        if let index = subTasks.firstIndex(where: { $0.id == subTask.id }) {
            subTasks.remove(at: index)
        }
    }
    
    public mutating func updateSubTask(_ subTask: SubTask) {
        if let index = subTasks.firstIndex(where: { $0.id == subTask.id }) {
            subTasks[index] = subTask
        }
    }
    
    public var countOfFinishedSubTasks: Int {
        subTasks.filter { $0.isCompleted }.count
    }
    
    public var startTime: String {
        startAt.formatted(date: .omitted, time: .shortened)
    }
    
    public var endTime: String {
        endAt.formatted(date: .omitted, time: .shortened)
    }
    
    public var duration: String {
        let interval = Int(endAt.timeIntervalSince1970 - startAt.timeIntervalSince1970)
        if interval < 3600 {
            let minu = interval / 60
            return "\(minu) \(minu > 1 ? "minutes" : "minute")"
        } else {
            let hour = interval / 3600
            if interval % 3600 == 0 {
                return "\(hour) \(hour > 1 ? "hours" : "hour")"
            }
            return String(format: "%.1f hours", Double(interval) / 3600.0)
        }
    }
}

extension TKTask {
    init(taskMO: TaskMO) {
        var subTasks: [SubTask] = []
        if let tasks = taskMO.subTasks {
            for ele in tasks {
                subTasks.append(SubTask(subTaskMO: ele as! SubTaskMO))
            }
        }
        self.init(id: taskMO.id!,
                  title: taskMO.title!,
                  createAt: taskMO.createdAt!,
                  isCompleted: taskMO.isCompleted,
                  remind: Remind(minutes: Int(taskMO.remind)),
                  startAt: taskMO.startDate ?? Date(),
                  endAt: taskMO.endDate ?? Date().advanced(by: 3600),
                  content: taskMO.content ?? "",
                  subTasks: subTasks)
    }
}

extension SubTask {
    init(subTaskMO: SubTaskMO) {
        self.init(id: subTaskMO.id!, title: subTaskMO.title!, isCompleted: subTaskMO.isCompleted)
    }
}
