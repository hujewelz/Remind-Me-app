//
//  TODOApp.swift
//  Shared
//
//  Created by huluobo on 2022/1/5.
//

import SwiftUI

@main
struct TODOApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            Home()
//            ContentView(store: ToDoStore(service: persistenceController))
//                .environment(\.locale, .init(identifier: "zh"))
        }
    }
}
