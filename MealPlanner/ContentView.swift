//
//  ContentView.swift
//  MealPlanner
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = MealViewModel()

    var body: some View {
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
    }
}

#Preview {
    ContentView()
}
