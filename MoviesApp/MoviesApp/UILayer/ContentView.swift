//
//  ContentView.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State var currentTab : String = "Home"
    @State var showMenu : Bool = false    
    
    init(dependencies: MoviesViewModelDependencies){
        self.viewModel = ViewModel(dependencies: dependencies)
    }
    
    var body: some View {
        VStack {
           // Login(dependencies: viewModel.dependencies)
            HomeWithSideMenu(dependencies: viewModel.dependencies)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

protocol MoviesViewModelDependencies: LoginModelDependencies, HomeViewModelDependencies, HomeWithSideMenuDependencies {
    
//    var nowPlayingUseCase: NowPlayingUseCase {get}
//    var upcomingUseCase: UpcomingUseCase {get}
//    var popularUseCase: PopularUseCase{get}
//    var topRatedUseCase: TopRatedUseCase {get}
}

extension ContentView{
    final class ViewModel : ObservableObject {
        let dependencies: MoviesViewModelDependencies
        
        init(dependencies: MoviesViewModelDependencies) {
            self.dependencies = dependencies
        }
    }
}
