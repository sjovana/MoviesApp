//
//  HomeView.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var activeTab: ViewModel.t = .nowPlaying

    init(dependencies: HomeViewModelDependencies){
        self.viewModel = ViewModel(dependencies: dependencies)
    }
    
    var body: some View {
        Group {
            switch viewModel.viewState{
            case .initial:
                ProgressView()
                    .onAppear{
                        viewModel.loadNowPlaying()
                    }
            case .loading:
                popCorn
                
            case .error:
                Text("error")
            case .finished:
                presentationView
            }
        }
    }
    
    var popCorn : some View {
        VStack{
            Image("popcorn 1")
                .resizable()
                .frame(width: 189, height: 189)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{
            Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                .ignoresSafeArea()

        }
    }
    
    var presentationView : some View {
        NavigationView {
            VStack{
                HStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(viewModel.nowPlayingg) { poster in
                                NavigationLink(destination: DetailView(dependencies: viewModel.dependencies, movieId: poster.id) ){
                                    nowPlayingCell(data: poster)
                                        .frame(width: 144.61, height: 210)
                                        .overlay(alignment: .bottomLeading){
                                            Text("\(viewModel.nowPlayingg.firstIndex(of: poster)!+1)")
                                                .shadow(color: .blue, radius: 2.5)
                                                .foregroundColor(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                                                .font(Font.system(size: 96).bold())
                                                .offset(x:-10, y:40)
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding(10)
                    }
                }
                VStack{
                    HStack{
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                ForEach(ViewModel.t.allCases, id: \.rawValue) { type in
                                    Text(type.rawValue)
                                        .padding(.leading,2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .background(alignment: .bottom, content: {
                                            if activeTab == type {
                                                Capsule()
                                                    .fill(Color(red: 0.22745098, green: 0.24705882, blue: 0.27843137))
                                                    .frame(height: 4)
                                                    .padding(.horizontal, -5)
                                                    .offset(y:10)
                                            }
                                        })
                                        .padding(3)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.3)){
                                                activeTab = type
                                            }
                                        }
                                }
                            }
                            if activeTab == .nowPlaying {
                                nowPlayingGrid
                            }
                            else if activeTab == .topRated {
                                topRatedGrid
                            }
                            else if activeTab == .upcoming {
                                upcomingGrid
                            }
                            else if activeTab == .popular{
                                popularGrid
                            }

                        }
                        .padding(.vertical, 15)
                    }
                }
                Spacer()
            }
            .navigationTitle("What do you want to watch?")
                .navigationBarTitleDisplayMode(.inline)
            .background{
                Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                    .ignoresSafeArea()
            }
        }
    }
    
    struct nowPlayingCell : View {
        let data : NowPlayingData
        
        var body: some View {
            HStack{
                    WebImage(url: data.posterPathURL)
                        .resizable()
                        .cornerRadius(16)
            }
        }
    }
    
    struct popularCell : View {
        let data : PopularData

        var body: some View {
            HStack{
                    WebImage(url: data.posterPathURL)
                        .resizable()
                        .cornerRadius(16)
            }
        }
    }
    
    struct upcomingCell : View {
        let data : UpcomingData

        var body: some View {
            HStack{
                    WebImage(url: data.posterPathURL)
                        .resizable()
                        .cornerRadius(16)
            }
        }
    }
    
    struct topRatedCell : View {
        let data : TopRatedData

        var body: some View {
            HStack{
                    WebImage(url: data.posterPathURL)
                        .resizable()
                        .cornerRadius(16)
            }
        }
    }
    
    var popularGrid :  some View  {
            VStack{
                let columns = Array(repeating: GridItem(.flexible()), count: 3)
                ScrollView {
                    LazyVGrid(columns: columns){
                        ForEach(viewModel.popular){poster in
                            NavigationLink(destination: DetailView(dependencies: viewModel.dependencies, movieId: poster.id)){
                                popularCell(data: poster)
                                    .frame(width: 100, height: 145.92)
                                    .padding(5)
                            }
                        }
                    }
                }
            }
        }
    
    var topRatedGrid :  some View  {
        VStack{
            let columns = Array(repeating: GridItem(.flexible()), count: 3)
            ScrollView {
                LazyVGrid(columns: columns){
                    ForEach(viewModel.topRated){poster in
                        NavigationLink(destination: DetailView(dependencies: viewModel.dependencies, movieId: poster.id)){
                            topRatedCell(data: poster)
                                .frame(width: 100, height: 145.92)
                                .padding(5)
                        }
                    }
                }
            }
        }
    }
    
    var upcomingGrid :  some View  {
        VStack{
            let columns = Array(repeating: GridItem(.flexible()), count: 3)
            ScrollView {
                LazyVGrid(columns: columns){
                    ForEach(viewModel.upcoming){poster in
                        NavigationLink(destination: DetailView(dependencies: viewModel.dependencies, movieId: poster.id)){
                            upcomingCell(data: poster)
                                .frame(width: 100, height: 145.92)
                                .padding(5)
                        }
                    }
                }
            }
        }
    }
    
    var nowPlayingGrid :  some View  {
        VStack{
            let columns = Array(repeating: GridItem(.flexible()), count: 3)
            ScrollView {
                LazyVGrid(columns: columns){
                    ForEach(viewModel.nowPlayingg){poster in
                        NavigationLink(destination: DetailView(dependencies: viewModel.dependencies, movieId: poster.id)){
                            nowPlayingCell(data: poster)
                                .frame(width: 100, height: 145.92)
                                .padding(5)
                        }
                    }
                }
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
protocol HomeViewModelDependencies: DetailViewModelDependencies {
    
    var nowPlayingUseCase: NowPlayingUseCase {get}
    var upcomingUseCase: UpcomingUseCase {get}
    var popularUseCase: PopularUseCase{get}
    var topRatedUseCase: TopRatedUseCase {get}
}

extension HomeView {
    final class ViewModel: ObservableObject{
        let dependencies: HomeViewModelDependencies
    
        @Published var viewState: ViewState = .initial
        
        @Published var nowPlayingg = [NowPlayingData]()
        @Published var upcoming = [UpcomingData]()
        @Published var popular = [PopularData]()
        @Published var topRated = [TopRatedData]()
    
        
        init(dependencies: HomeViewModelDependencies) {
            self.dependencies = dependencies
        }

        enum ViewState {
            case initial
            case loading
            case error
            case finished
            
        }
        
        struct typee : Identifiable, Hashable, Equatable {
            var id: UUID = UUID()
            var typeee: t
        }

        enum t : String, CaseIterable {
            case nowPlaying = "Now playing"
            case upcoming = "Upcoming"
            case topRated = "Top rated"
            case popular = "Popular"
        }
        
        private var subscriptions = Set<AnyCancellable>()
        
        func loadNowPlaying() {
            viewState = .loading
            
            dependencies.nowPlayingUseCase.fetchNowPlaying()
                .sink(receiveCompletion: { completion in
                    switch completion{
                    case .failure:
                        self.viewState = .error
                    case .finished:
                        self.viewState = .finished
                    }
                    
                }, receiveValue: { data in
                    self.nowPlayingg = data
                    //print(data.count)
                   // self.viewState = .finished
                    self.loadUpcoming()
                }
                )
                .store(in: &subscriptions)
        }
        func loadUpcoming() {
            viewState = .loading
            
            dependencies.upcomingUseCase.fetchUpcoming()
                .sink(receiveCompletion: { completion in
                    switch completion{
                    case .failure:
                        self.viewState = .error
                    case .finished:
                        self.viewState = .finished
                    }
                    
                }, receiveValue: { data in
                    self.upcoming = data
                    //print(data.count)
                   // self.viewState = .finished
                    self.loadPopular()
                }
                )
                .store(in: &subscriptions)
        }
        func loadPopular() {
            dependencies.popularUseCase.fetchPopular()
                .sink(receiveCompletion: {completion in
                    switch completion{
                    case .failure:
                        self.viewState = .error
                    case .finished:
                        self.viewState = .finished
                    }
                }, receiveValue:{ data in
                    self.popular = data
                    self.loadTopRated()
                }
                )
                .store(in: &subscriptions)
        }
        func loadTopRated()
        {
            dependencies.topRatedUseCase.fetchTopRated()
                .sink(receiveCompletion: {completion in
                    switch completion{
                    case .failure:
                        self.viewState = .error
                    case .finished:
                        self.viewState = .finished
                    }
                }, receiveValue:{ data in
                    self.topRated = data
                    //print(data.count)
                    self.viewState = .finished
                }
                )
                .store(in: &subscriptions)
        }
    }
}

