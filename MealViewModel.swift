import Foundation
import Combine

class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var averageRating: Double = 0.0
    @Published var userRating: Int? = nil

    func submitRating(for meal: Meal, rating: Int) {
        // Update meal rating logic
        if let index = meals.firstIndex(where: { $0.name == meal.name }) {
            meals[index].rating = rating
            calculateAverageRating()
            userRating = rating // Store the user's rating
        }
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