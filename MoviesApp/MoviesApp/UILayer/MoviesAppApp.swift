//
//  MoviesAppApp.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import SwiftUI
import Combine

@main
struct MoviesAppApp: App {
    @ObservedObject var viewModel = ViewModel()
    
    init () {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(dependencies: viewModel.dependencyContainer)
                .environmentObject(viewModel)
        }
    }
}

extension MoviesAppApp{
    final class ViewModel : ObservableObject{
        let dependencyContainer = AppDependenciesContainer()
    }
}
