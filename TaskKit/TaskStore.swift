//
//  TaskStore.swift
//  TaskKit
//
//  Created by luobobo on 2022/6/20.
//

import Foundation
import SwiftUI

public final class TaskStore: ObservableObject, Store {
//    let server: TaskServer
    
    @Published public var state: [Task] = []
    
    public var reducer: ([Task]?, TaskAction) async -> [Task]
    
    public init(server: TaskServer) {
//        self.server = server
        
        reducer = { prevState, action in
            switch action {
            case .fetch(let date):
                return await server.fetchTasks(of: date)
            case .update(let task):
                await server.updateTask(task)
                if let index = prevState?.firstIndex(where: { $0.id == task.id }) {
                    var tmp = prevState!
                    tmp[index] = task
                    return tmp
                }
                return prevState ?? []
            }
        }
    }
    
    
}

public enum TaskAction {
    case fetch(Date)
    case update(Task)
}
