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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
