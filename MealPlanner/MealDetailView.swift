//
//  MealDetailView.swift
//  MealPlanner
//

import SwiftUI

struct MealDetailView: View {
    let mealId: String
    let title: String
    let thumb: String

    @State private var detail: MealDetail?
    @State private var isLoading = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let d = detail {
                    if let url = URL(string: d.strMealThumb ?? "") {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFit()
                        } placeholder: { ProgressView() }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Text("Instructions").font(.headline)
                    Text(d.strInstructions ?? "—")

                    Text("Ingredients").font(.headline).padding(.top, 8)
                    ForEach(d.ingredientsList(), id: \.self) { item in
                        Text("• \(item)")
                    }
                } else if isLoading {
                    ProgressView()
                } else {
                    Text("No details found.")
                }
            }
            .padding()
        }
        .navigationTitle(title)
        .task {
            do { detail = try await MealAPI.lookup(id: mealId) }
            catch { print("Lookup error:", error) }
            isLoading = false
        }
    }
}

