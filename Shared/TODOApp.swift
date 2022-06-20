//
//  TODOApp.swift
//  Shared
//
//  Created by huluobo on 2022/1/5.
//

import SwiftUI
import TaskKit

@main
struct TODOApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            Home(store: TaskStore(server: persistenceController))
        }
        
    }
}
