//
//  WatchList.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//
import Foundation
import SwiftUI
import Combine
import SDWebImage
import SDWebImageSwiftUI

class RefreshManager {
    static let shared = RefreshManager()
    
    let refreshSubject = PassthroughSubject<Void, Never>()
    
    private init() {
        print("RefreshManager initialized")
    }

}

struct WatchList: View {
    
    @ObservedObject var viewModel : ViewModel
   
    init(dependencies: WatchListViewModelDependencies) {
        self.viewModel = ViewModel(dependencies: dependencies)
    }
    var body: some View {
        Group {
            switch viewModel.viewState{
            case .initial:
               ProgressView()
            case .loading:
                ProgressView()
            case .error:
                Text("error")
            case .finished:
                presentation
            }
        }
    }
    var presentation : some View {
        NavigationView {
            VStack{
                HStack{
                    if viewModel.movies.isEmpty {
                        empty
                    }
                    else{
                       list
                    }
                }
              Spacer()
            }
                .onReceive(viewModel.refreshSubject) { _ in
                    viewModel.fetchAllStoredMovieIds()
                }
            .navigationTitle("Watch list")
                .navigationBarTitleDisplayMode(.inline)
            .background{
                Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                    .ignoresSafeArea()
            }
        }
     
    }
    var list : some View {
        VStack{
            List{
                ForEach(Array(Set(viewModel.movies)), id: \.id) { movie in
                    if viewModel.dependencies.movieWatchListUseCase.isInWatchList(id: movie.id){
                        cell(data: movie)
                            .listRowBackground(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                    }
                }
            }
        }
        .background{
            Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                .ignoresSafeArea()
        }
        .scrollContentBackground(.hidden)
    }
    var empty: some View {
        VStack{
            Image("Group-2")
                .resizable()
                .frame(width: 63.76, height: 76)
            Text("There Is No Movie Yet!")
                .font(.title.bold())
                .foregroundColor(.white)
            Text("")
            Text("Find your movie by Type title,")
                .font(.headline)
                .foregroundColor(.gray)
            Text("categories, years, etc")
                .font(.headline)
                .foregroundColor(.gray)
               
        }
    }
    
    struct cell : View {
        let data: MovieData
        
        var body : some View{
            VStack{
                HStack{
                    VStack{
                        WebImage(url: data.posterPathURL)
                            .resizable()
                            .frame(width: 95, height: 120)
                            .cornerRadius(16)
                    }
                    VStack{
                        HStack{
                            Text("\(data.title)")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        HStack{
                            Text("")
                        }
                        
                        HStack{
                            let voteAverage = String (format: "%.1f" , data.voteAverage)
                            Image(systemName: "star")
                                .foregroundColor(Color(red: 1 , green: 0.52941176, blue: 0))
                                .frame(width: 13, height: 12.5)
                            Text("\(voteAverage)")
                                .foregroundColor(Color(red: 1 , green: 0.52941176, blue: 0))
                                .font(.system(size: 12))
                            Spacer()
                        }
                        
                        HStack{
                            Image(systemName: "circle.square")
                                .frame(width: 11, height: 11)
                                .foregroundColor(.white)
                            Text("\(data.genresName)")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        
                        HStack{
                            Image(systemName: "calendar")
                                .frame(width: 11, height: 11)
                                .foregroundColor(.white)
                            Text(String(data.releaseDate.prefix(4)))
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        HStack{
                            Image(systemName: "clock")
                                .frame(width: 12, height: 12)
                                .foregroundColor(.white)
                            Text("\(data.runTime) minutes")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    
                }
                .padding()
            }
        }
    }
}

protocol WatchListViewModelDependencies {
    
    var getAllWatchListMoviesUseCase : GetAllWatchListMoviesUseCase {get}
    var movieUseCase: MovieUseCase {get}
    var refreshSubject: AnyPublisher<Void, Never> { get }
    var movieWatchListUseCase : MovieWatchListUseCase {get}
}

extension WatchList {
    final class ViewModel: ObservableObject {
        
        let refreshSubject = RefreshManager.shared.refreshSubject
        let dependencies: WatchListViewModelDependencies
        
        init(dependencies: WatchListViewModelDependencies) {
            self.dependencies = dependencies
            
        fetchAllStoredMovieIds()

        }

        @Published var movies = [MovieData]()
        @Published var viewState : ViewState = .initial
        @State private var movieData: [MovieData] = []
        
        enum ViewState {
            case initial
            case loading
            case error
            case finished
        }
        
        private var subscriptions = Set<AnyCancellable>()
        
        func fetchAllStoredMovieIds () {

            viewState = .loading

            let ids = dependencies.getAllWatchListMoviesUseCase.fetchAllStoredMovieIds()

            var fetchedCount = 0

            ids.forEach { id in
                dependencies.movieUseCase.fetchMovie(id: id)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure (let error):
                            print(error.localizedDescription)
                            self.viewState = .error
                        case .finished:
                            fetchedCount += 1
                            if fetchedCount == ids.count {
                                self.viewState = .finished
                            }
                        }
                    }, receiveValue: { data in
                        self.movies.append(data)
                    })
                    .store(in: &subscriptions)
            }
        }
    }
}
