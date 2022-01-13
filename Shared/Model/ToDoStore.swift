//
//  ToDoStore.swift
//  TODO
//
//  Created by huluobo on 2022/1/5.
//

import SwiftUI

final class ToDoStore: ObservableObject {
    
    typealias GroupedTodos = (title: GroupTitle, value: [Todo])
    
    let todoService: TodoService
    
    @Published var todos: [GroupedTodos] = []
    @Published var searchResult: [GroupedTodos] = []
    @Published var selectedTodo: Todo?
    @Published var currenTodoTitle = ""
    @Published var searchText = "" {
        didSet {
            print("searched: ", searchText)
            searchTodo(title: searchText)
        }
    }
    
    private var allTodo: [Todo] = [] {
        didSet {
            var tmp: [GroupedTodos] = []
            let todos = allTodo.filter { !$0.isCompleted }.sorted { $0.timestamp > $1.timestamp }
            let completed = allTodo.filter { $0.isCompleted }.sorted { $0.timestamp > $1.timestamp }
            if !todos.isEmpty {
                tmp.append((.todo, todos))
            }
            if !completed.isEmpty {
                tmp.append((.completed, completed))
            }
            self.todos = tmp
        }
    }
    
    init(service: TodoService) {
        todoService = service
        fetchAll()
    }
    
    enum GroupTitle: String {
        case todo = "Todo"
        case completed = "Completed"
    }
    
    func create(_ todo: Todo) {
        withAnimation {
            allTodo.insert(todo, at: 0)
        }
        todoService.create(todo)
    }
    
    func delete(_ todo: Todo) {
        guard let index = index(of: todo) else { return }
        
        withAnimation {
            allTodo.remove(at: index)
        }
        todoService.delete(todo)
    }
    
    func toggleRemind(_ todo: Todo) {
        guard !todo.isCompleted else { return }
        var todo = todo
        todo.isRemind.toggle()
        update(todo)
    }
    
    func toggleCompletion(_ todo: Todo) {
        var todo = todo
        todo.isCompleted.toggle()
        
        withAnimation {
            update(todo)
        }
    }
    
    func addOrUpdateTodo(title: String) {
        guard !title.isAbsoluteEmpty else { return }
        if var selectedTodo = selectedTodo {
            if selectedTodo.title != title.absoluteText {
                selectedTodo.title = title.absoluteText
                update(selectedTodo)
            }
            self.selectedTodo = nil
        } else {
            create(Todo(title: title.absoluteText))
        }
    }
    
   
    func searchTodo(title: String) {
        if title.isAbsoluteEmpty {
            
        } else {
    
        }
    }
}

extension ToDoStore {
    private func index(of todo: Todo) -> Int? {
        allTodo.firstIndex(where: { $0.id == todo.id })
    }

    private func fetchAll() {
        allTodo = todoService.fetchAll()
    }
    
    private func update(_ todo: Todo) {
        if let index = allTodo.firstIndex(where: { $0.id == todo.id }) {
            allTodo[index] = todo
            todoService.update(todo)
        }
    }
}
