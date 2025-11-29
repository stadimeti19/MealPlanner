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
    @Published var mealPlans: [MealPlan] = []

    init() {
        retrieveMealPlans()
    }

    func search() async {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return }
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do { results = try await MealAPI.search(byIngredient: q) }
        catch { errorMessage = error.localizedDescription }
    }
    
    func createMealPlan(name: String, meals: [MealBrief]) {
        let newMealPlan = MealPlan(name: name, meals: meals)
        mealPlans.append(newMealPlan)
        saveMealPlans()
    }
    
    func saveMealPlans() {
        if let encoded = try? PropertyListEncoder().encode(mealPlans) {
            UserDefaults.standard.set(encoded, forKey: "mealPlans")
        }
    }
    
    func retrieveMealPlans() {
        if let data = UserDefaults.standard.value(forKey: "mealPlans") as? Data {
            mealPlans = (try? PropertyListDecoder().decode([MealPlan].self, from: data)) ?? []
        }
    }
}

struct MealPlan: Codable {
    let name: String
    let meals: [MealBrief]
}