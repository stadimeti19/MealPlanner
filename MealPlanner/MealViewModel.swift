//
//  MealViewModel.swift
//  MealPlanner
//

import Foundation

@MainActor
final class MealViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [MealBrief] = []
    @Published var mealPlans: [MealPlan] = [] // New property to hold meal plans
    @Published var isLoading = false
    @Published var errorMessage: String?

    func search() async {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return }
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do { results = try await MealAPI.search(byIngredient: q) }
        catch { errorMessage = error.localizedDescription }
    }
    
    func fetchMealPlans() async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do { mealPlans = try await MealAPI.fetchMealPlans() } // New function to fetch meal plans
        catch { errorMessage = error.localizedDescription }
    }
    
    func createMealPlan(_ mealPlan: MealPlan) async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            let createdMealPlan = try await MealAPI.createMealPlan(mealPlan) // New function to create a meal plan
            mealPlans.append(createdMealPlan)
        } catch { errorMessage = error.localizedDescription }
    }
    
    func updateMealPlan(_ mealPlan: MealPlan) async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            let updatedMealPlan = try await MealAPI.updateMealPlan(mealPlan) // New function to update a meal plan
            if let index = mealPlans.firstIndex(where: { $0.id == updatedMealPlan.id }) {
                mealPlans[index] = updatedMealPlan
            }
        } catch { errorMessage = error.localizedDescription }
    }
    
    func deleteMealPlan(_ mealPlan: MealPlan) async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            try await MealAPI.deleteMealPlan(mealPlan.id) // New function to delete a meal plan
            mealPlans.removeAll { $0.id == mealPlan.id }
        } catch { errorMessage = error.localizedDescription }
    }
}