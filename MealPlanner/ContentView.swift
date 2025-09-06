//
//  ContentView.swift
//  MealPlanner
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = MealViewModel()
    @EnvironmentObject private var favorites: FavoritesStore

    
    var body: some View {
        TabView {
            NavigationStack {
                VStack(spacing: 12) {
                    HStack {
                        TextField("ingredient (e.g., chicken, tomato)", text: $vm.query)
                            .textFieldStyle(.roundedBorder)
                        Button("Search") { Task { await vm.search() } }
                            .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)

                    if vm.isLoading { ProgressView().padding() }
                    if let e = vm.errorMessage { Text(e).foregroundColor(.red) }

                    List(vm.results) { meal in
                        NavigationLink(meal.strMeal) {
                            MealDetailView(mealId: meal.idMeal, title: meal.strMeal, thumb: meal.strMealThumb)
                        }
                    }
                }
                .navigationTitle("Meal Planner")
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }

            SavedView()
                .tabItem { Label("Saved", systemImage: "heart") }
        }
    }
}

#Preview {
    ContentView()
}
