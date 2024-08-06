//
//  RecipeBrowserAppApp.swift
//  RecipeBrowserApp
//
//  Created by Simon Huang on 8/2/24.
//

import SwiftUI

@main
struct RecipeBrowserAppApp: App {
    @State var isFinishedLaunching = false
    
    var body: some Scene {
        WindowGroup {
            if isFinishedLaunching {
                HomeView()
            } else {
                LaunchView(isFinishedLaunch: $isFinishedLaunching)
            }
            
        }   
    }
}
