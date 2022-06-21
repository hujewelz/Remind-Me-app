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
                if let index = prevState?.firstIndex(where: { $0.id == task.id }) {
                    var tmp = prevState!
                    tmp[index] = task
                    return tmp
                }
                return ((prevState ?? []) + [task]).sorted(by: {$0.startAt > $1.startAt })
            }
        }
    }
}

public enum TaskAction {
    case fetch(Date)
    case update(TKTask)
}
