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
    @State private var newIngredient: String = ""
    @State private var newInstruction: String = ""
    @State private var ingredients: [String] = []
    @State private var instructions: [String] = []
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

                    Text("Instructions").font(.headline)
                    ForEach(instructions, id: \.self) { instruction in
                        Text("• \(instruction)")
                    }

                    Text("Ingredients").font(.headline).padding(.top)
                    ForEach(ingredients, id: \.self) { item in
                        Text("• \(item)")
                    }
                } else if isLoading {
                    ProgressView()
                } else {
                    Text("No details found.")
                }

                VStack(alignment: .leading) {
                    TextField("Add new ingredient", text: $newIngredient)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top)

                    Button("Add Ingredient") {
                        if !newIngredient.isEmpty {
                            ingredients.append(newIngredient)
                            newIngredient = ""
                        }
                    }
                    .buttonStyle(.bordered)

                    TextField("Add new instruction", text: $newInstruction)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top)

                    Button("Add Instruction") {
                        if !newInstruction.isEmpty {
                            instructions.append(newInstruction)
                            newInstruction = ""
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top)
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
        }
        .task {
            do { detail = try await MealAPI.lookup(id: mealId) }
            catch { print("Lookup error:", error) }
            isLoading = false
        }
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
        }
    }
}