//
//  ScienceFictionView.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 22.8.23..
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

struct ScienceFictionView: View {
    
    @ObservedObject var viewModel: ViewModel

    init(dependencies: ScienceFictionDependencies){
        self.viewModel = ViewModel(dependencies: dependencies)
    }

    var body: some View {
        Group {
            switch viewModel.viewState{
            case .initial:
                ProgressView()
                    .onAppear{
                        viewModel.loadNowPlayinggggggg()
                    }
            case .loading:
                popCorn
            case .error:
                Text("error")
            case .finished:
                presentation
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
        
    var presentation : some View {
        NavigationView{
            VStack{
                let columns = Array(repeating: GridItem(.flexible()), count: 3)
                ScrollView {
                    LazyVGrid(columns: columns){
                        ForEach(viewModel.scienceFictionMovies){movie in
                            NavigationLink(destination: DetailView(dependencies: viewModel.dependencies, movieId: movie.id)){
                                nowPlayingCell(data: movie)
                                    .frame(width: 100, height: 145.92)
                                    .padding(5)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Science fiction")
                .navigationBarTitleDisplayMode(.inline)
            .background{
                Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                    .ignoresSafeArea()
            }
        }
    }
    
}

//struct Action_Previews: PreviewProvider {
//
//    static var previews: some View {
//        Action()
//    }
//}

protocol ScienceFictionDependencies : HomeViewModelDependencies, DetailViewModelDependencies {

}
extension ScienceFictionView {
    final class ViewModel : ObservableObject{
        
        let dependencies: ScienceFictionDependencies
        
        @Published var viewState: ViewState = .initial
        @Published var nowPlayingg = [NowPlayingData]()
        @Published var movies: [MovieData] = []
        @Published var scienceFictionMovies: [NowPlayingData] = []
        
      
        
        init(dependencies: ScienceFictionDependencies) {
            self.dependencies = dependencies
        }
        
        enum ViewState {
            case initial
            case loading
            case error
            case finished
            
        }
        
        var filteredMovies : [NowPlayingData] {
            let scienceFictionMovieIds = movies.filter{$0.genresName == "science fiction" } .map { $0.id}
            return nowPlayingg.filter { scienceFictionMovieIds.contains($0.id) }
        }
        
        private var subscriptions = Set<AnyCancellable>()

        func loadNowPlayinggggggg() {
            viewState = .loading
            
            dependencies.nowPlayingUseCase.fetchNowPlaying()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        self.viewState = .error
                    case .finished:
                        self.viewState = .finished
                    }
                    
                }, receiveValue: { data in
                    self.nowPlayingg = data
                    self.filterScienceFictionMovies()
                    self.viewState = .finished
                })
                .store(in: &subscriptions)
        }

        private func filterScienceFictionMovies() {
            let group = DispatchGroup()
            
            for movie in nowPlayingg {
                group.enter()
                dependencies.movieUseCase.fetchMovie(id: movie.id)
                    .sink(receiveCompletion: { _ in
                        group.leave()
                    }, receiveValue: { movieDetails in
                        if movieDetails.genresName.contains("Science Fiction") {
                            DispatchQueue.main.async {
                                self.scienceFictionMovies.append(movie)
                            }
                        }
                    })
                    .store(in: &self.subscriptions)
            }
            
            group.notify(queue: .main) {
                
            }
        }
    }
}
