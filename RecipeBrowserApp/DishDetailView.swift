//
//  DishDetailView.swift
//  RecipeBrowserApp
//
//  Created by Simon Huang on 8/5/24.
//

import SwiftUI

struct DishDetailView: View {
    
    @Binding var selectedDishId: String
    
    @State var couldLoadDetails = true
    
    @State var dishDetails: DishDetails?
    
    var body: some View {
        GeometryReader {geo in
            NavigationView {
                if let dishDetails = dishDetails {
                    ZStack {
                        AsyncImage(url: URL(string: dishDetails.strMealThumb),
                        transaction: Transaction(animation: .default)) {phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .edgesIgnoringSafeArea(.all)
                            }
                        }
                        
                        ScrollView {
                            VStack {
                                VStack(alignment: .center) {
                                    Text(dishDetails.strMeal)
                                        .font(.largeTitle)
                                    Text(dishDetails.strArea)
                                        .padding(.bottom, 50)
                                    Text("Ingredients for dish")
                                        .font(.title3)
                                }

                                // Loop through ingredient array and display them
                                VStack(alignment: .leading) {
                                    ForEach(Array(zip(dishDetails.strIngredientSummary.indices, dishDetails.strIngredientSummary )),  id: \.0) { index, item in
                                            Text(String(index+1) + ". " + item)
                                            .padding(.bottom, 20)
                                    }
                                }
                                .padding()
                                .frame(width: geo.size.width, alignment: .leading)
                            }
                            .frame(width: geo.size.width)
                            
                            Text("Instructions")
                                .font(.title3)
                            
                            Text(dishDetails.strInstructions)
                                .font(.caption)
                                .padding()
                        }
                        .padding()
                        .frame(width: geo.size.width)
                        .background(.white.opacity(0.85))
                    }
                } else {
                    if couldLoadDetails {
                        ProgressView()
                            .controlSize(.extraLarge)
                    } else {
                        Text("Could Not load details for dish")
                            .font(.title2)
                    }
                }
            }
            .onAppear {
                Task {
                    dishDetails = try await Api.getDishDetails(dishId: selectedDishId)
                    
                    if dishDetails == nil {
                        couldLoadDetails = false
                    }
                }
            }
        }
    }
        
}

#Preview {
    struct Preview : View {
        @State var test = "53049"
        
        var body: some View {
            DishDetailView(selectedDishId: $test)
        }
    }
    return Preview()
}
