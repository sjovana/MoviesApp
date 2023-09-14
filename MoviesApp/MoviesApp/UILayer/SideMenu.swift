//
//  SideMenu.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 13.8.23..
//

import SwiftUI

struct SideMenuu: View {
    
    @ObservedObject var viewModel: ViewModel
    @Binding var isMenuVisible: Bool
    @Binding private var selectedMenuItem: String?
   
    init(dependencies: SideMenuDependencies, isMenuVisible: Binding<Bool>, selectedMenuItem: Binding<String?>){
           self.viewModel = ViewModel(dependencies: dependencies)
           _isMenuVisible = isMenuVisible
           _selectedMenuItem = selectedMenuItem
       }
  
    var body: some View {
        VStack{
            List {
                Button("Home") {
                    selectedMenuItem = "Home"
                    isMenuVisible = false
                    }
                .foregroundColor(Color.white)
                .listRowBackground(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                .background{
                    Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                        .ignoresSafeArea()
                }
                
                Button("Action") {
                    selectedMenuItem = "Action"
                    isMenuVisible = false
                    }
                .foregroundColor(Color.white)
                .listRowBackground(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                .background{
                    Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                        .ignoresSafeArea()
                }
                Button("Drama") {
                    selectedMenuItem = "Drama"
                    isMenuVisible = false
                    }
                .foregroundColor(Color.white)
                .listRowBackground(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                .background{
                    Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                        .ignoresSafeArea()
                }
                Button("Animation") {
                    selectedMenuItem = "Animation"
                    isMenuVisible = false
                    }
                .foregroundColor(Color.white)
                .listRowBackground(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                .background{
                    Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                        .ignoresSafeArea()
                }
                Button("Comedy") {
                    selectedMenuItem = "Comedy"
                    isMenuVisible = false
                    }
                .foregroundColor(Color.white)
                .listRowBackground(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                .background{
                    Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                        .ignoresSafeArea()
                }
                Button("Science Fiction") {
                    selectedMenuItem = "Science Fiction"
                    isMenuVisible = false
                    }
                .foregroundColor(Color.white)
                .listRowBackground(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                .background{
                    Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                        .ignoresSafeArea()
                }
                Button("Adventure") {
                    selectedMenuItem = "Adventure"
                    isMenuVisible = false
                    }
                .foregroundColor(Color.white)
                .listRowBackground(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                .background{
                    Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                        .ignoresSafeArea()
                }
                Button("Family") {
                    selectedMenuItem = "Family"
                    isMenuVisible = false
                    }
                .foregroundColor(Color.white)
                .listRowBackground(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                .background{
                    Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                        .ignoresSafeArea()
                }
                Button("Horror") {
                    selectedMenuItem = "Horror"
                    isMenuVisible = false
                    }
                .foregroundColor(Color.white)
                .listRowBackground(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                .background{
                    Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                        .ignoresSafeArea()
                .listRowBackground(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                }
                Button("Thriller") {
                    selectedMenuItem = "Thriller"
                    isMenuVisible = false
                    }
                .foregroundColor(Color.white)
                .background{
                    Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                        .ignoresSafeArea()
                }
                .listRowBackground(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                       
                }
                .listStyle(SidebarListStyle())
                .background{
                    Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                        .ignoresSafeArea()
                }
        }
        .background{
            Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                .ignoresSafeArea()
        }
        .scrollContentBackground(.hidden)
    }

}

//struct SideMenuu_Previews: PreviewProvider {
//    static var previews: some View {
//        SideMenuu()
//    }
//}


protocol SideMenuDependencies : HomeViewModelDependencies, DetailViewModelDependencies, WatchListViewModelDependencies,LoginModelDependencies, SearchViewModelDependencies, DramaDependencies, AnimationDependencies, ActionDependencies, ComedyDependencies, ScienceFictionDependencies, AdventureDependencies, FamilyDependencies, HorrorDependencies, ThrillerDependencies{
    
    var nowPlayingUseCase: NowPlayingUseCase {get}
    var upcomingUseCase: UpcomingUseCase {get}
    var popularUseCase: PopularUseCase{get}
    var topRatedUseCase: TopRatedUseCase {get}
}

extension SideMenuu{
    final class ViewModel : ObservableObject {
        let dependencies: SideMenuDependencies
        
        init(dependencies: SideMenuDependencies) {
            self.dependencies = dependencies
        }
    }
}
