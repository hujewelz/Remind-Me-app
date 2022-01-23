//
//  TODOApp.swift
//  Shared
//
//  Created by huluobo on 2022/1/5.
//

import SwiftUI
import FirebaseStore

@main
struct TODOApp: App {
    let persistenceController = PersistenceController.shared
    let firebaseStore: FirebaseStore
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        firebaseStore = FirebaseStore()
        firebaseStore.setup()
    }

    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(firebaseStore)
//            ContentView(store: ToDoStore(service: persistenceController))
//                .environment(\.locale, .init(identifier: "zh"))
        }
        
    }
}
