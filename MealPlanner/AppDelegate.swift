//
//  AppDelegate.swift
//  MealPlanner
//

import SwiftUI
import UIKit
import FirebaseCore
import FirebaseAuth

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configure Firebase first
        FirebaseApp.configure()
        print("Firebase configured successfully")
        return true
    }
}


