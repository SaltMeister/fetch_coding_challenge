//
//  HomeView.swift
//  RecipeBrowserApp
//
//  Created by Simon Huang on 8/2/24.
//

import SwiftUI

struct HomeView: View {
    @State var dishTypeList: DishTypeList = DishTypeList(categories: [])
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    Spacer()
                    Text("What dish are you looking for?")
                        .font(.title2)
                        .padding()
                    
                        LazyVGrid(columns: columns, spacing: 2) {
                            if dishTypeList.categories.isEmpty {
                                ProgressView()
                            }
                            
                            // Display 2 items per grid row
                            ForEach(dishTypeList.categories, id: \.idCategory) { dishType in
                                GridRow {
                                    NavigationLink(destination: DishListView(dishType: .constant(dishType.strCategory))) {
                                        VStack {
                                            AsyncImage(
                                                url: URL(string: dishType.strCategoryThumb),
                                                transaction: Transaction(animation: .default)
                                            ) { phase in
                                                if let image = phase.image { image
                                                    .resizable()
                                                    .scaledToFit()
                                                }
                                                else { ProgressView() }
                                            }
                                            .frame(maxWidth: 200, maxHeight: 200)
                                        
                                            Text(dishType.strCategory)
                                        }
                                        .padding(5)
                                    }
                                    .foregroundColor(.black)
                                }
                            }
                      }
                }
            }
        }
        .onAppear {
            Task{
                dishTypeList = try await Api.getAllDishGenre()
            }
        }
    }
}

#Preview {
    HomeView()
}
