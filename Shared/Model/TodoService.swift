//
//  TodoService.swift
//  TODO
//
//  Created by huluobo on 2022/1/12.
//

import Foundation

protocol TodoService {
    func create(_ todo: Todo)
    
    func update(_ todo: Todo)
    
    func fetchAll() -> [Todo]
    
    func fetchTo(withId id: UUID) -> Todo?
    
    func delete(_ todo: Todo)
}
