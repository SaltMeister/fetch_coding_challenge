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

struct DishMutablePreviewList : Codable {
    var meals: [DishPreview]
}

struct DishPreview : Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

// Struct to hold details for a specific dish
struct DishDetails : Codable {
    let strMeal: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strYoutube: String
    let strIngredientSummary: [String]
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
        
        // Grab Dishes and sort them beforre returning immutable struct
        var dishPreviewList = try JSONDecoder().decode(DishMutablePreviewList.self, from: data)
        
        dishPreviewList.meals.sort(by: {$0.strMeal < $1.strMeal})
        
        return DishPreviewList(meals: dishPreviewList.meals)
        
    }
    
    static public func getDishDetails(dishId: String) async throws -> DishDetails? {
        //return DishDetails()
        let url = URL(string: API_DISH_DETAIL_URL + dishId)
        guard let url = url else {
            print("Url is not valid")
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let json = json else {
            print("Could Not Parse JSON into Dict")
            return nil
        }
        
        if let data = json["meals"] as? [[String: Any]] {
            let result = parseDishDetailIntoStruct(json: data[0])
            return result
        }
        return nil
    }
    
    // Combines Ingredients and Measurements for Dish into single array
    static private func parseDishDetailIntoStruct(json : [String: Any]) -> DishDetails {
        let ingredientString = "strIngredient"
        let measurementString = "strMeasure"
        let maxIngredientsFromJson = 20
        
        var ingredientsList: [String] = []
        var strInstructions = ""
        var strMeal = ""
        var strYoutube = ""
        var strMealThumb = ""
        var strArea = ""
        
        // Loop Combine ingredients into array of strings
        for index in 1 ... maxIngredientsFromJson {
            let currentIngred = ingredientString + String(index)
            let currentMeasure = measurementString + String(index)
            
            var stringToAdd = ""

            if let ingred = json[currentIngred] as? String {
                if ingred.isEmpty || ingred.allSatisfy({ $0.isWhitespace }) {
                    continue
                }
                stringToAdd += ingred + ": "
            } else {
                continue
            }
            
            if let measure = json[currentMeasure] as? String {
                if measure.isEmpty || measure.allSatisfy({ $0.isWhitespace }) {
                    continue
                }
                stringToAdd += measure
            } else {
                continue
            }

            ingredientsList.append(stringToAdd)
        }
        
        // Casting Any to strings for use in struct
        if let mealName = json["strMeal"] as? String {
            strMeal = mealName
        }
        if let dishArea = json["strArea"] as? String {
            strArea = dishArea
        }
        // Get Data
        if let intruction = json["strInstructions"] as? String {
            strInstructions = intruction
        }
        if let youtubeUrl = json["strYoutube"] as? String {
            strYoutube = youtubeUrl
        }
        if let strThumbnail = json["strMealThumb"] as? String {
            strMealThumb = strThumbnail
        }
        
        return DishDetails(strMeal: strMeal, strArea: strArea,
                           strInstructions: strInstructions,
                           strMealThumb: strMealThumb, strYoutube: strYoutube,
                           strIngredientSummary: ingredientsList)
    }
}
