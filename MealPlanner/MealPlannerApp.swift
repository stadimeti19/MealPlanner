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
    @StateObject private var authManager = AuthManager()
    @StateObject private var favoritesStore = FavoritesStore()
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                ContentView()
                    .environmentObject(favoritesStore)
                    .environmentObject(authManager)
            } else {
                AuthView()
                    .environmentObject(authManager)
            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore
    @EnvironmentObject var authManager: AuthManager
    @State private var selection: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                // Main content goes here
                
                Spacer()
                
                NavigationLink(destination: ContentView(), tag: 1, selection: $selection) {
                    Button(action: {
                        selection = 1
                    }) {
                        Text("Home")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Meal Planner")
            .navigationBarItems(leading: Button(action: {
                selection = nil
            }) {
                Text("Back")
            })
            .onAppear {
                selection = nil
            }
        }
    }
}