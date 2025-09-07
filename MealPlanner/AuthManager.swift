//
//  AuthManager.swift
//  MealPlanner
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    init() {
        // Listen for auth state changes
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.currentUser = user
                self?.isAuthenticated = user != nil
                print("Auth state changed - isAuthenticated: \(user != nil)")
            }
        }
        
        // Check if user is already signed in
        currentUser = Auth.auth().currentUser
        isAuthenticated = currentUser != nil
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully")
        } catch {
            print("Sign out error: \(error)")
        }
    }
}
