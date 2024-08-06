//
//  DishListView.swift
//  RecipeBrowserApp
//
//  Created by Simon Huang on 8/3/24.
//

import SwiftUI

struct DishListView: View {
    @Binding var dishType: String
    
    @State var dishSummaryList : DishPreviewList = DishPreviewList(meals: [])
    
    var body: some View {
        let columns = [GridItem(alignment: .top), (GridItem(alignment: .top))]
        NavigationView {
            ScrollView(.vertical) {
                VStack{
                    Text("\(dishType) Dishes")
                        .font(.title)
                    
                    LazyVGrid(columns: columns, spacing: 30) {
                        
                        ForEach(dishSummaryList.meals, id: \.idMeal) { dishSummary in
                            NavigationLink(destination: DishDetailView(selectedDishId: .constant(dishSummary.idMeal))) {
                                
                                VStack {
                                    AsyncImage(
                                    url: URL(string: dishSummary.strMealThumb),
                                    transaction: Transaction(animation: .default)) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        } else { ProgressView() }
                                    }
                                    .frame(maxWidth: 200, maxHeight: 200)
                                    
                                    Text(dishSummary.strMeal)
                                        .scaledToFit()
                                        .lineLimit(1)
                                }
                            }
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                dishSummaryList = try await Api.getAllDishSummaryForGenre(genre: dishType)
            }
        }
    }
}

#Preview {
    DishListView(dishType: .constant("Beef"))
}
