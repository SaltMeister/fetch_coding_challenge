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

struct DishPreviewList : Codable {
    let meals: [DishPreview]
}

struct DishPreview : Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

struct DishDetailsList : Codable {

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
    static private let API_DISH_TYPE_URL = "https://www.themealdb.com/api/json/v1/1/categories.php"
    
    // Partial string will be filled out in function
    static private let API_DISH_GENRE_PREVIEW_URL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    static private let API_DISH_DETAIL_URL = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
        
    static public func getAllDishGenre() async throws -> DishTypeList {
        let url = URL(string: API_DISH_TYPE_URL)
        guard let url = url else {
            print("Url is not valid")
            return DishTypeList(categories: [])
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let dishTypeList = try JSONDecoder().decode(DishTypeList.self, from: data)
        return dishTypeList
    }
    
    static public func getAllDishSummaryForGenre(genre: String) async throws -> DishPreviewList {
        let url = URL(string: API_DISH_GENRE_PREVIEW_URL + genre)
        
        guard let url = url else {
            print("Url is not valid")
            return DishPreviewList(meals: [])
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        print(data)
        let dishPreviewList = try JSONDecoder().decode(DishPreviewList.self, from: data)
        
        return dishPreviewList
        
    }
    
    static public func getDishDetails(dishId: String) async throws -> Void {
        //return DishDetails()
        let url = URL(string: API_DISH_DETAIL_URL + dishId)
        guard let url = url else {
            print("Url is not valid")
            return //DishTypeList(categories: [])
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let json = json else {
            print("Could Not Parse JSON into Dict")
            return
        }
        
        print(json)
        
    }
}
