//
//  TaskServer.swift
//  TaskKit
//
//  Created by huluobo on 2022/1/26.
//

import Foundation

public protocol TaskServer {
    func fetchTasks(of date: Date) async -> [Task]
    
    func updateTask(_ task: Task)
    
    func deleteTask(_ task: Task)
    
    func updateSubTask(_ subTask: SubTask, of task: Task)

    func deleteSubTask(_ subTask: SubTask, of task: Task) 
    
}
