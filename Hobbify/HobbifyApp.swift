//
//  HobbifyApp.swift
//  Hobbify
//
//  Created by Max Bricker on 27/1/2025.
//

import SwiftUI

@main
struct HobbifyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
