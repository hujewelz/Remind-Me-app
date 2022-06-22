//
//  NewTaskViewModel.swift
//  TODO
//
//  Created by luobobo on 2022/6/21.
//

import Foundation
import TaskKit
import SwiftUI


final class NewTaskViewModel: ObservableObject {
    @Published var task: TKTask
    
    init(task: TKTask?) {
        var task = task
        if task == nil {
            task = TKTask(title: "")
            task?.startAt = Date()
            task?.endAt = Date().advanced(by: 3600)
        }
        self.task = task!
    }
    
    func deleteSubTask(_ subTask: SubTask) {
        guard let index = task.subTasks.firstIndex(where: { $0.id == subTask.id }) else { return }
        
        withAnimation {
            let _ = task.subTasks.remove(at: index)
        }
    }
    
    func addEmptySubTask() {
        withAnimation {
            task.subTasks.append(SubTask())
        }
    }
}
