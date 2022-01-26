//
//  Persistence.swift
//  Shared
//
//  Created by huluobo on 2022/1/5.
//

import CoreData

public struct PersistenceController {
    public static let shared = PersistenceController()

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

extension PersistenceController: TaskServer {
    
    public func fetchTasks(of date: Date) async -> [Task] {
        let result = fetchMOs(TaskMO.self, predicate: date.todayPredicate)
        if case .success(let mos) = result {
            return mos.map(Task.init(taskMO:))
        }
        return []
    }
    
    public func updateTask(_ task: Task)  {
        var mo = fetchMO(TaskMO.self, byId: task.id)
        if mo == nil {
            mo = TaskMO(context: container.viewContext)
            mo!.id = task.id
            mo?.createdAt = task.createAt
        }
        mo?.title = task.title
        mo?.content = task.content
        mo?.startDate = task.startAt
        mo?.endDate = task.endAt
        mo?.isCompleted = task.isCompleted
        mo?.isRemind = task.isRemind
        
        task.subTasks.forEach { subTask in
            updateSubTaskWithoutSave(subTask, of: task)
        }
        
        save()
    }
    
    public func deleteTask(_ task: Task)  {
        guard let mo = fetchMO(TaskMO.self, byId: task.id) else { return }
        container.viewContext.delete(mo)
        save()
    }
    
    public func updateSubTask(_ subTask: SubTask, of task: Task)  {
        updateSubTaskWithoutSave(subTask, of: task)
        save()
    }
    
    public func deleteSubTask(_ subTask: SubTask, of task: Task)  {
        guard let mo = fetchMO(TaskMO.self, byId: task.id),
              let subTaskMO = fetchMO(SubTaskMO.self, byId: subTask.id) else { return }
        mo.removeFromSubTasks(subTaskMO)
        save()
    }
    
    private func updateSubTaskWithoutSave(_ subTask: SubTask, of task: Task) {
        guard let mo = fetchMO(TaskMO.self, byId: task.id) else { return }
        
        var subTaskMO = fetchMO(SubTaskMO.self, byId: subTask.id)
        if subTaskMO == nil {
            subTaskMO = SubTaskMO(context: container.viewContext)
            subTaskMO?.id = subTask.id
        }
        subTaskMO?.title = subTask.title
        subTaskMO?.isCompleted = subTask.isCompleted
        if let index = mo.subTasks?.index(of: subTaskMO!) {
            mo.replaceSubTasks(at: index, with: subTaskMO!)
        } else {
            mo.addToSubTasks(subTaskMO!)
        }
    }
    
    private func fetchMO<T: NSManagedObject>(_ type: T.Type, byId id: UUID) -> T? {
        let predicate = NSPredicate(format: "id = %@", id as CVarArg)
        let result = fetchFirst(type.self, predicate: predicate)
        if case .success(let mo) = result {
            return mo
        }
        return nil
    }
}

extension Date {
    var todayPredicate: NSPredicate {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let startDate = calendar.date(from: components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)
        return NSPredicate(format: "createdAt >= %@ AND createdAt =< %@", startDate! as CVarArg, endDate! as CVarArg)
    }
}
