//
//  LaunchView.swift
//  RecipeBrowserApp
//
//  Created by Simon Huang on 8/2/24.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    @Binding var isFinishedLaunch: Bool
    
    var body: some View {
        VStack {
            Text("Dish Dictionary")
                .font(.largeTitle)
                .padding(5)
            Text("Recipes at your fingertips")
                .font(.title2)
        }
        .scaleEffect(size)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                self.size = 0.9
                self.opacity = 1.0
            }
            
            // Timer before launch screen closes and loads home
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeIn(duration: 0.5)) {
                    self.isFinishedLaunch = true
                }
            }
        }

    }
}

#Preview {
    LaunchView(isFinishedLaunch: .constant(false))
}
