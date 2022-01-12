//
//  Persistence.swift
//  Shared
//
//  Created by huluobo on 2022/1/5.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = TodoMO(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TODO")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

extension PersistenceController {
    private func fetchMOs<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate? = nil, limit: Int? = nil) -> Result<[T], Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        if let limit = limit {
            request.fetchLimit = limit
        }
        do {
            let result = try container.viewContext.fetch(request)
            return .success(result as? [T] ?? [])
        } catch {
            return .failure(error)
        }
    }
    
    private func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate? = nil) -> Result<T?, Error> {
        let result = fetchMOs(objectType, predicate: predicate, limit: 1)
        switch result {
        case .success(let todos):
            return .success(todos.first)
        case .failure(let error):
            return .failure(error)
        }
    }
}

extension PersistenceController: TodoService {
    func fetchTo(withId id: UUID) -> Todo? {
        let mo = todoMO(withId: id)
        return mo?.todo
    }
    
    private func todoMO(withId id: UUID) -> TodoMO? {
        let predicate = NSPredicate(format: "uuid = %@", id as CVarArg)
        let result = fetchFirst(TodoMO.self, predicate: predicate)
        if case .success(let mo) = result {
            return mo
        }
        return nil
    }
    
    
    func create(_ todo: Todo) {
        let todoMO = TodoMO(context: container.viewContext)
        todoMO.id = todo.id
        todoMO.title = todo.title
        todoMO.isCompleted = todo.isCompleted
        todoMO.isRemind = todo.isRemind
        todoMO.timestamp = todo.timestamp
        todoMO.startDate = todo.startDate
        todoMO.dueDate = todo.dueDate
        todoMO.content = todo.content
        save()
    }
    
    func update(_ todo: Todo) {
        let mo = todoMO(withId: todo.id)
        mo?.title = todo.title
        mo?.isCompleted = todo.isCompleted
        mo?.isRemind = todo.isRemind
        mo?.startDate = todo.startDate
        mo?.dueDate = todo.dueDate
        mo?.content = todo.content
        save()
    }
    
    func fetchAll() -> [Todo] {
        let result = fetchMOs(TodoMO.self)
        if case .success(let mos) = result {
            return mos.map(Todo.init(todoMO:))
        }
        return []
    }
}
