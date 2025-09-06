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

    func search() async {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return }
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do { results = try await MealAPI.search(byIngredient: q) }
        catch { errorMessage = error.localizedDescription }
    }
}
