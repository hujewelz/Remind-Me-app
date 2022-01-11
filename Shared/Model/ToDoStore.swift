//
//  ToDoStore.swift
//  TODO
//
//  Created by huluobo on 2022/1/5.
//

import SwiftUI
import CoreData

final class ToDoStore: ObservableObject {
    @Published var title: String
    @Published var content: String
    @Published var duteData: Date
    @Published var isComplete = false
    @Published var isRemind = false
    @Published var steps: [String] = []
    
    @Published var bellRotation: Double
    
    private var todo: Todo?
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext, todo: Todo?) {
        self.context = context
        self.todo = todo
        title = todo?.title ?? ""
        content = todo?.content ?? ""
        duteData = todo?.dueDate ?? Date()
        isRemind = todo?.isRemind ?? false
        isComplete = todo?.isCompleted ?? false
        bellRotation = (todo?.isRemind ?? false) ? 20 : 0
    }
    
    func toggleRemind() {
        bellRotation = isRemind ? 0 : 20
        isRemind.toggle()
    }
    
    func saveItem() {
        
        let newItem = todo ?? Todo(context: context)
        newItem.title = title
        newItem.content = content
        newItem.dueDate = duteData
        newItem.isRemind = isRemind
        newItem.isCompleted = isComplete
        if todo == nil {
            newItem.id = UUID()
            newItem.timestamp = Date()
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteItem() {
        guard let todo = todo else {
            return
        }
        context.delete(todo)
    }
}
