//
//  SentByCentApp.swift
//  SentByCent
//
//  Created by Atif Mahmood on 3/7/25.
//

import SwiftUI

@main
struct SentByCentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


