//
//  SavedView.swift
//  MealPlanner
//

import SwiftUI

struct SavedView: View {
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        NavigationStack {
            List(favorites.favorites) { fav in
                NavigationLink(fav.title) {
                    MealDetailView(mealId: fav.id, title: fav.title, thumb: fav.thumb)
                }
            }
            .navigationTitle("Saved Meals")
        }
    }
}

#Preview {
    SavedView()
        .environmentObject(FavoritesStore())
}


