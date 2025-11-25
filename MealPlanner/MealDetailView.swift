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
    @State private var isEditing = false
    @State private var ingredients: [String] = []
    @State private var instructions: String = ""
    @EnvironmentObject private var favorites: FavoritesStore

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

                    if isEditing {
                        TextField("Instructions", text: $instructions)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 8)

                        Text("Ingredients").font(.headline).padding(.top, 8)
                        ForEach(ingredients.indices, id: \.self) { index in
                            TextField("Ingredient", text: $ingredients[index])
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        Button(action: addIngredient) {
                            Text("Add Ingredient")
                        }
                        .padding(.top, 8)
                    } else {
                        Text("Instructions").font(.headline)
                        Text(d.strInstructions ?? "—")

                        Text("Ingredients").font(.headline).padding(.top, 8)
                        ForEach(d.ingredientsList(), id: \.self) { item in
                            Text("• \(item)")
                        }
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { Task { await toggleFavorite() } }) {
                    HStack {
                        Image(systemName: favorites.isSaved(mealId: mealId) ? "heart.fill" : "heart")
                        Text(favorites.isSaved(mealId: mealId) ? "Saved" : "Save")
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { isEditing.toggle() }) {
                    Text(isEditing ? "Done" : "Edit")
                }
            }
        }
        .task {
            do {
                detail = try await MealAPI.lookup(id: mealId)
                ingredients = d.ingredientsList()
                instructions = d.strInstructions ?? ""
            } catch {
                print("Lookup error:", error)
            }
            isLoading = false
        }
    
    private func addIngredient() {
        ingredients.append("")
    }
}

extension MealDetailView {
    private func toggleFavorite() async {
        do {
            if favorites.isSaved(mealId: mealId) {
                print("Removing favorite: \(mealId)")
                try await favorites.remove(mealId: mealId)
                print("Successfully removed favorite")
            } else {
                print("Saving favorite: \(mealId) - \(title)")
                try await favorites.save(mealId: mealId, title: title, thumb: thumb)
                print("Successfully saved favorite")
            }
        } catch {
            print("Favorite toggle error:", error)
            // You could add user-facing error alerts here
        }
    }
}