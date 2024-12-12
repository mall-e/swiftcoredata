//
//  mobilApp.swift
//  mobil
//
//  Created by Muhammet Ali Yazıcı on 12.12.2024.
//

import SwiftUI

@main
struct mobilApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
