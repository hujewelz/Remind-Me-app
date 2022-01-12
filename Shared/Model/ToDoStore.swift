//
//  ToDoStore.swift
//  TODO
//
//  Created by huluobo on 2022/1/5.
//

import SwiftUI

final class ToDoStore: ObservableObject {
    
    typealias GroupedTodos = (title: String, value: [Todo])
    
    let todoService: TodoService
    
    @Published var todos: [GroupedTodos] = []
    
    init(service: TodoService) {
        todoService = service
        fetchAll()
    }
    
    
}

extension ToDoStore {

    func create(_ todo: Todo) {
        withAnimation {
            if var todoGroup = todos.first(where: { $0.title == "Todo" }) {
                todoGroup.value.insert(todo, at: 0)
                todos[0] = todoGroup
            } else {
                self.todos.insert(("Todo", [todo]), at: 0)
            }
        }
        
        todoService.create(todo)
    }
    
    func update(_ todo: Todo) {
        todoService.update(todo)
    }
    
    func fetchAll() {
        let results = todoService.fetchAll()
        let todos = results.filter { !$0.isCompleted }.sorted { $0.timestamp > $1.timestamp }
        let completed = results.filter { $0.isCompleted }.sorted { $0.timestamp > $1.timestamp }
        
        if !todos.isEmpty {
            self.todos.append(("Todo", todos))
        }
        
        if !completed.isEmpty {
            self.todos.append(("Completed", completed))
        }
    }
}
