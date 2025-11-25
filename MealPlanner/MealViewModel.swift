//
//  MealViewModel.swift
//  MealPlanner
//

import Foundation

@MainActor
final class MealViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [MealBrief] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedMeal: MealBrief? // New property to hold the selected meal
    @Published var mealCategories: [String] = [] // New property for meal categories

    func search() async {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return }
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do { 
            results = try await MealAPI.search(byIngredient: q) 
            mealCategories = extractCategories(from: results) // Populate meal categories based on results
        }
        catch { errorMessage = error.localizedDescription }
    }

    private func extractCategories(from meals: [MealBrief]) -> [String] {
        // Extract unique categories from the meal results
        let categories = meals.compactMap { $0.category }.unique() // Assuming MealBrief has a category property
        return categories
    }
}

extension Array where Element: Hashable {
    func unique() -> [Element] {
        return Array(Set(self))
    }
}