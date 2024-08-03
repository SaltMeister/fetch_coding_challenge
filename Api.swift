//
//  Api.swift
//  RecipeBrowserApp
//
//  Created by Simon Huang on 8/2/24.
//  Utilizing the API from the url:
//  https://themealdb.com/api.php
//  using the endpoints MEALS and MEAL_ID
//
import Foundation


struct DishTypeList : Codable {
    let categories: [DishType]
}
struct DishType : Codable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
}

// Struct to hold details for a specific dish
struct DishDetails : Codable {
    let idMeal: String
    let strMeal: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strYoutube: String
    let strIngredientSummary: [String : String]
}

class Api {
    static let API_DISH_TYPE_URL = "https://www.themealdb.com/api/json/v1/1/categories.php"

    static public func getAllDishGenre() async throws -> DishTypeList {
        let url = URL(string: API_DISH_TYPE_URL)
        guard let unwrappedUrl = url else {
            print("Url is not valid")
            return DishTypeList(categories: [])
        }
        
        let (data, _) = try await URLSession.shared.data(from: unwrappedUrl)
        print(data)
        let dishTypeList = try JSONDecoder().decode(DishTypeList.self, from: data)
        print(dishTypeList)
        return dishTypeList
    }
}
