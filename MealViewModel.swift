import Foundation
import Combine

class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var averageRating: Double = 0.0
    @Published var userRating: Int? = nil

    func submitRating(for meal: Meal, rating: Int) {
        // Update meal rating logic
        meal.rating = rating
        calculateAverageRating()
    }

    private func calculateAverageRating() {
        let totalRatings = meals.reduce(0) { $0 + ($1.rating ?? 0) }
        let ratedMealsCount = meals.filter { $0.rating != nil }.count
        averageRating = ratedMealsCount > 0 ? Double(totalRatings) / Double(ratedMealsCount) : 0.0
    }
}

struct Meal {
    var name: String
    var rating: Int?
}