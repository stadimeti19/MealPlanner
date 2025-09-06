//
//  MealPlannerApp.swift
//  MealPlanner
//
//  Created by Sashank Tadimeti on 9/5/25.
//

import SwiftUI
import FirebaseCore

@main
struct MealPlannerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var favoritesStore = FavoritesStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesStore)
        }
    }
}
