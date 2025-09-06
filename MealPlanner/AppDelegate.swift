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
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        Auth.auth().signInAnonymously { _, error in
            if let error = error {
                print("Anonymous auth error: \(error)")
            }
        }
        return true
    }
}


