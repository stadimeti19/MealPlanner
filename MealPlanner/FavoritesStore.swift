//
//  FavoritesStore.swift
//  MealPlanner
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

struct Favorite: Identifiable, Equatable {
    let id: String       // mealId
    let title: String
    let thumb: String
}

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var favorites: [Favorite] = []

    private var authListener: AuthStateDidChangeListenerHandle?
    private var firestoreListener: ListenerRegistration?

    init() {
        // Start listening for auth; once we have a user, attach Firestore listener
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            Task { @MainActor in
                self.detachFirestoreListener()
                if user != nil {
                    self.attachFirestoreListener()
                } else {
                    self.favorites = []
                }
            }
        }
        // If already signed in (e.g., anonymous), attach immediately
        if Auth.auth().currentUser != nil {
            attachFirestoreListener()
        }
    }

    // No explicit deinit cleanup needed; this store lives for app lifetime.

    private func userFavoritesCollection() -> CollectionReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Firestore.firestore().collection("users").document(uid).collection("favorites")
    }

    private func attachFirestoreListener() {
        guard firestoreListener == nil, let col = userFavoritesCollection() else { return }
        firestoreListener = col.order(by: FieldPath.documentID()).addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Favorites listener error: \(error)")
                return
            }
            let docs = snapshot?.documents ?? []
            Task { @MainActor in
                self.favorites = docs.compactMap { doc in
                    let data = doc.data()
                    let title = data["title"] as? String ?? ""
                    let thumb = data["thumb"] as? String ?? ""
                    return Favorite(id: doc.documentID, title: title, thumb: thumb)
                }
            }
        }
    }

    private func detachFirestoreListener() {
        firestoreListener?.remove()
        firestoreListener = nil
    }

    func isSaved(mealId: String) -> Bool {
        favorites.contains { $0.id == mealId }
    }

    func save(mealId: String, title: String, thumb: String) async throws {
        guard let col = userFavoritesCollection() else { return }
        try await col.document(mealId).setData([
            "title": title,
            "thumb": thumb
        ], merge: true)
    }

    func remove(mealId: String) async throws {
        guard let col = userFavoritesCollection() else { return }
        try await col.document(mealId).delete()
    }
}


