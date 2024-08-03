//
//  HomeView.swift
//  RecipeBrowserApp
//
//  Created by Simon Huang on 8/2/24.
//

import SwiftUI

struct HomeView: View {
    @State var dishType: [DishType] = []
    
    var body: some View {
        VStack {
            Spacer()
            Text("What kind of dish are you looking for?")
            NavigationStack {
                Grid {
                    if dishType.isEmpty {
                        ProgressView()
                    }

                    
                    // Display 2 items per grid row
                    ForEach(0 ..< dishType.count/2, id: \.self) {index in
                        GridRow{
                            VStack {
                                let item1Index = index * 2
                                Text(dishType[item1Index].strCategory)
                                AsyncImage(url: URL(string: dishType[item1Index].strCategoryThumb)) { result in
                                    result.image?
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(maxWidth: 200, maxHeight: 2000)
                            }
                            .padding(5)
                            .onTapGesture {
                                
                            }
                            
                            VStack {
                                let item2Index = index * 2 + 1
                                Text(dishType[item2Index].strCategory)
                                AsyncImage(url: URL(string: dishType[item2Index].strCategoryThumb)) { result in
                                    result.image?
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(maxWidth: 200, maxHeight: 200)
                            }
                            .padding(5)
                            .onTapGesture {
                                
                            }
                        }
                        
                    }
                }
            }
           
        }
        .onAppear {
            Task{
                dishType = try await Api.getAllDishGenre().categories
            }
        }

    }
}

#Preview {
    HomeView()
}
