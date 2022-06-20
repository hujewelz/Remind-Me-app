//
//  TaskServer.swift
//  TaskKit
//
//  Created by huluobo on 2022/1/26.
//

import Foundation

public protocol TaskServer {
    func fetchTasks(of date: Date) async -> [Task]
    
    func updateTask(_ task: Task) async
    
    func deleteTask(_ task: Task) async
    
    func updateSubTask(_ subTask: SubTask, of task: Task) async

    func deleteSubTask(_ subTask: SubTask, of task: Task) async
    
}
