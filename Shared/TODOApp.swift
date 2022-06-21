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

    let store  = TaskStore(server: PersistenceController())
    
    var body: some Scene {
        WindowGroup {
            Home(store: store)
        }
        
    }
}
