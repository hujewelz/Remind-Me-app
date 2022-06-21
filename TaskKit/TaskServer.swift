//
//  TaskServer.swift
//  TaskKit
//
//  Created by huluobo on 2022/1/26.
//

import Foundation

public protocol TaskServer {
    func fetchTasks(of date: Date) async -> [TKTask]
    
    func updateTask(_ task: TKTask) async
    
    func deleteTask(_ task: TKTask) async
    
    func updateSubTask(_ subTask: SubTask, of task: TKTask) async

    func deleteSubTask(_ subTask: SubTask, of task: TKTask) async
    
}
