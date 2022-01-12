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
    @Published var selectedTodo: Todo?
    @Published var currenTodoTitle = ""
    @Published var searchText = "" {
        didSet {
            print("searched: ", searchText)
            searchTodo(title: searchText)
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
            if var todoGroup = todos(from: .todo) {
                todoGroup.insert(todo, at: 0)
                todos[0] = (.todo, todoGroup)
            } else {
                self.todos.insert((.todo, [todo]), at: 0)
            }
        }
        todoService.create(todo)
    }
    
    func delete(_ todo: Todo) {
        let currentGroup: GroupTitle = todo.isCompleted ? .completed : .todo
        let grouped = remove(todo, in: currentGroup)
        let indexOfGroup = todo.isCompleted ? 1 : 0
        withAnimation {
            if grouped.value.isEmpty {
                todos.remove(at: indexOfGroup)
            } else {
                todos[indexOfGroup] = grouped
            }
        }
        todoService.delete(todo)
    }
    
    func toggleRemind(_ todo: Todo) {
        guard !todo.isCompleted else { return }
        
        var todo = todo
        todo.isRemind.toggle()
        update(todo)
//        guard var todoGroup = todos(from: .todo),
//              let index = todoGroup.firstIndex(where: { $0.id == todo.id }) else { return }
//
//        todoGroup[index] = todo
//        todos[0] = (.todo, todoGroup)
//        todoService.update(todo)
    }
    
    func toggleCompletion(_ todo: Todo) {
        var todo = todo
        todo.isCompleted.toggle()
        let currentGroup: GroupTitle = todo.isCompleted ? .todo : .completed
        let newGroup: GroupTitle = todo.isCompleted ? .completed : .todo
        let currentGroupTodos = remove(todo, in: currentGroup)
        let newGroupTodos = insert(todo, in: newGroup)
        withAnimation {
            if todo.isCompleted {
                //  此时 currentGroupTodos 代表 Todo group
                var tmp = [newGroupTodos]
                if !currentGroupTodos.value.isEmpty {
                    tmp.insert(currentGroupTodos, at: 0)
                }
                todos = tmp
            } else {
                // 此时 currentGroupTodos 代表 Completed group
                var tmp = [newGroupTodos]
                if !currentGroupTodos.value.isEmpty {
                    tmp.append(currentGroupTodos)
                }
                todos = tmp
            }
            
        }
        todoService.update(todo)
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
    
    private var originalTodos: [GroupedTodos] = []
    func searchTodo(title: String) {
        if title.isAbsoluteEmpty {
            todos = originalTodos
            print("end search: ", originalTodos.count)
        } else {
            var tmp: [GroupedTodos] = []
            if let todoGroup = todos(from: .todo)?.filter({ $0.title.contains(title.absoluteText) }), !todoGroup.isEmpty {
                tmp.append((.todo, todoGroup))
            }
            if let completedGroup = todos(from: .todo)?.filter({ $0.title.contains(title.absoluteText) }), !completedGroup.isEmpty {
                tmp.append((.completed, completedGroup))
            }
            todos = tmp
            print("searched: ", originalTodos.count)
        }
    }
}

extension ToDoStore {
    private func todos(from group: GroupTitle) -> [Todo]? {
        guard let result = todos.first(where: { $0.title == group }) else { return nil }
        return result.value
    }
    
    private func remove(_ todo: Todo, in group: GroupTitle) -> GroupedTodos {
        guard var grouped = todos(from: group) else { return (group, []) }
        
        if let index = grouped.firstIndex(where: { $0.id == todo.id }) {
            grouped.remove(at: index)
        }
        return (group, grouped)
    }
    
    private func insert(_ todo: Todo, in group: GroupTitle) -> GroupedTodos {
        guard var grouped = todos(from: group) else { return (group, [todo]) }
        grouped.insert(todo, at: 0)
        grouped.sort { $0.timestamp > $1.timestamp }
        return (group, grouped)
    }
    
    private func fetchAll() {
        let results = todoService.fetchAll()
        let todos = results.filter { !$0.isCompleted }.sorted { $0.timestamp > $1.timestamp }
        let completed = results.filter { $0.isCompleted }.sorted { $0.timestamp > $1.timestamp }
        
        if !todos.isEmpty {
            self.todos.append((.todo, todos))
        }
        
        if !completed.isEmpty {
            self.todos.append((.completed, completed))
        }
    }
    
    private func update(_ todo: Todo) {
        let currentGroup: GroupTitle = todo.isCompleted ? .completed : .todo
        guard var todos = todos(from: currentGroup),
              let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        
        todos[index] = todo
        let indexOfCurrentGroup = currentGroup == .todo ? 0 : 1
        self.todos[indexOfCurrentGroup] = (currentGroup, todos)
    }
}
