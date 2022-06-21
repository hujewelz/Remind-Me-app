//
//  TaskStore.swift
//  TaskKit
//
//  Created by luobobo on 2022/6/20.
//

import Foundation
import Combine

public final class TaskStore: ObservableObject, Store {
    
    @Published public var state: [TKTask] = []
    
    public var reducer: ([TKTask]?, TaskAction) async -> [TKTask]
    
    public init(server: TaskServer) {
        reducer = { prevState, action in
            switch action {
            case .fetch(let date):
                return await server.fetchTasks(of: date)
            case .update(let task):
                await server.updateTask(task)
                var tasks = prevState ?? []
                if let index = prevState?.firstIndex(where: { $0.id == task.id }) { // update a task
                    tasks[index] = task
                } else { // create a new task
                    tasks = [task] + tasks
                }
                return tasks.sorted(by: {$0.startAt > $1.startAt })
            }
        }
    }
}

public enum TaskAction {
    case fetch(Date)
    case update(TKTask)
}
