//
//  Todo.swift
//  TODO
//
//  Created by huluobo on 2022/1/12.
//

import Foundation

struct Todo: Codable, Identifiable {
    var id: UUID
    var title: String
    var timestamp: Date
    var isCompleted: Bool
    var isRemind: Bool
    var startDate: Date?
    var dueDate: Date?
    var content: String?
}

extension Todo {
    init(title: String) {
        id = UUID()
        self.title = title
        timestamp = Date()
        isCompleted = false
        isRemind = false
    }
    
    init(todoMO: TodoMO) {
        self.init(id: todoMO.id ?? UUID(),
                  title: todoMO.title!,
                  timestamp: todoMO.timestamp!,
                  isCompleted: todoMO.isCompleted,
                  isRemind: todoMO.isRemind,
                  startDate: todoMO.startDate,
                  dueDate: todoMO.dueDate,
                  content: todoMO.content)
    }
}
