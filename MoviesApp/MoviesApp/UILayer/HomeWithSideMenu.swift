//
//  HomeWithSideMenu.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 23.8.23..
//

import SwiftUI

struct HomeWithSideMenu: View {
    
    @ObservedObject var viewModel : ViewModel
    
    @State private var isMenuVisible = false
    @State private var selectedMenuItem: String? = nil
    
    init(dependencies: HomeWithSideMenuDependencies){
        self.viewModel = ViewModel(dependencies: dependencies)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    
                    Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                        .ignoresSafeArea()
                    
                    if let selected = selectedMenuItem {
                        switch selected {
                        case "Home":
                            NavigationLink(destination: HomeView(dependencies: viewModel.dependencies),tag: selected, selection: $selectedMenuItem) {
                                EmptyView()
                                
                            }
                        case "Action":
                            NavigationLink(destination: Action(dependencies: viewModel.dependencies),tag: selected, selection: $selectedMenuItem) {
                                EmptyView()
                            }
                        case "Drama":
                            NavigationLink(destination: DramaView(dependencies: viewModel.dependencies),tag: selected, selection: $selectedMenuItem) {
                                EmptyView()
                            }
                        case "Animation":
                            NavigationLink(destination: AnimationView(dependencies: viewModel.dependencies),tag: selected, selection: $selectedMenuItem) {
                                EmptyView()
                            }
                        case "Science Fiction":
                            NavigationLink(destination: ScienceFictionView(dependencies: viewModel.dependencies),tag: selected, selection: $selectedMenuItem) {
                                EmptyView()
                            }
                        case "Adventure":
                            NavigationLink(destination: AdventureView(dependencies: viewModel.dependencies),tag: selected, selection: $selectedMenuItem) {
                                EmptyView()
                            }
                        case "Family":
                            NavigationLink(destination: FamilyView(dependencies: viewModel.dependencies),tag: selected, selection: $selectedMenuItem) {
                                EmptyView()
                            }
                        case "Horror":
                            NavigationLink(destination: HorrorView(dependencies: viewModel.dependencies),tag: selected, selection: $selectedMenuItem) {
                                EmptyView()
                            }
                        case "Thiller":
                            NavigationLink(destination: ThrillerView(dependencies: viewModel.dependencies),tag: selected, selection: $selectedMenuItem) {
                                EmptyView()
                            }
                        default:
                            EmptyView()
                        }
                    }
                    else{
                        presentation
                    }
                    if isMenuVisible {
                        SideMenuu(dependencies: viewModel.dependencies, isMenuVisible: $isMenuVisible, selectedMenuItem: $selectedMenuItem)
                            .transition(.move(edge: .leading))
                            .background{
                                Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                                    .ignoresSafeArea()
                            }
                        
                    }
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action: {
                    withAnimation {
                        isMenuVisible.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title)
                })
                .background{
                    Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                        .ignoresSafeArea()
                }
            }
            
        }
    }
    
    var presentation : some View {
        VStack{
            TabView{
                HomeView(dependencies: viewModel.dependencies)
                    .tabItem{
                        Label("Home", systemImage: "house")
                    }
                SearchView(dependencies: viewModel.dependencies)
                    .tabItem{
                        Label("Search", systemImage: "magnifyingglass")
                    }
            
                WatchList(dependencies: viewModel.dependencies )
                    .tabItem{
                        Label("Watch List", systemImage: "bookmark")
                }
            }
        }
    }
}

//struct HomeWithSideMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeWithSideMenu()
//    }
//}

protocol HomeWithSideMenuDependencies :  HomeViewModelDependencies, DetailViewModelDependencies, WatchListViewModelDependencies,LoginModelDependencies, SearchViewModelDependencies, DramaDependencies, AnimationDependencies, SideMenuDependencies {
    
}

extension HomeWithSideMenu{
    final class ViewModel : ObservableObject{
        let dependencies : HomeWithSideMenuDependencies
        
        init(dependencies: HomeWithSideMenuDependencies) {
            self.dependencies = dependencies
        }
    }
}
