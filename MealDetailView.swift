import SwiftUI

struct MealDetailView: View {
    var meal: Meal
    @State private var rating: Int = 0
    @State private var averageRating: Double = 0.0
    
    var body: some View {
        VStack {
            Text(meal.name)
                .font(.largeTitle)
            
            // Existing meal details...
            
            Text("Average Rating: \(String(format: "%.1f", averageRating))")
                .font(.headline)
            
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .onTapGesture {
                            self.rating = star
                            submitRating(star)
                        }
                }
            }
            .padding()
        }
        .onAppear {
            fetchAverageRating()
        }
    }
    
    private func fetchAverageRating() {
        // Call the backend API to retrieve the average rating for the meal
        let url = URL(string: "https://api.example.com/meals/\(meal.id)/averageRating")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            if let average = try? JSONDecoder().decode(Double.self, from: data) {
                DispatchQueue.main.async {
                    self.averageRating = average
                }
            }
        }
        task.resume()
    }
    
    private func submitRating(_ rating: Int) {
        // Call the backend API to submit the rating for the meal
        let url = URL(string: "https://api.example.com/meals/\(meal.id)/rate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["rating": rating]
        request.httpBody = try? JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle response if necessary
        }
        task.resume()
    }
}