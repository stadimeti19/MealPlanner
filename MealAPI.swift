import Foundation
import SQLite3

class MealAPI {
    // Existing methods...

    // New API endpoint for submitting a meal rating
    func submitMealRating(mealId: Int, userId: Int, rating: Int, completion: @escaping (Bool, Error?) -> Void) {
        let query = "INSERT INTO meal_ratings (meal_id, user_id, rating) VALUES (?, ?, ?)"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(mealId))
            sqlite3_bind_int(statement, 2, Int32(userId))
            sqlite3_bind_int(statement, 3, Int32(rating))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                completion(true, nil)
            } else {
                completion(false, NSError(domain: "MealAPI", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to submit rating"]))
            }
        } else {
            completion(false, NSError(domain: "MealAPI", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to prepare statement"]))
        }
        
        sqlite3_finalize(statement)
    }

    // New API endpoint for retrieving meal ratings
    func getMealRatings(mealId: Int, completion: @escaping ([Int], Error?) -> Void) {
        let query = "SELECT rating FROM meal_ratings WHERE meal_id = ?"
        var statement: OpaquePointer?
        var ratings: [Int] = []
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(mealId))
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let rating = sqlite3_column_int(statement, 0)
                ratings.append(Int(rating))
            }
            completion(ratings, nil)
        } else {
            completion([], NSError(domain: "MealAPI", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to prepare statement"]))
        }
        
        sqlite3_finalize(statement)
    }
    
    // New API endpoint for retrieving average meal rating
    func getAverageMealRating(mealId: Int, completion: @escaping (Double?, Error?) -> Void) {
        let query = "SELECT AVG(rating) FROM meal_ratings WHERE meal_id = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(mealId))
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let averageRating = sqlite3_column_double(statement, 0)
                completion(averageRating, nil)
            } else {
                completion(nil, NSError(domain: "MealAPI", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve average rating"]))
            }
        } else {
            completion(nil, NSError(domain: "MealAPI", code: 5, userInfo: [NSLocalizedDescriptionKey: "Failed to prepare statement"]))
        }
        
        sqlite3_finalize(statement)
    }
}