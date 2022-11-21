//
//  Dex3AppApp.swift
//  Dex3App
//
//  Created by GeoSpark on 18/11/22.
//

import SwiftUI

@main
struct Dex3AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
