//
//  DetailView.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import SwiftUI
import Combine
import SDWebImageSwiftUI
import Foundation


struct DetailView: View {
    
    @ObservedObject var viewModel : ViewModel
    @State private var activeTab : ViewModel.description = .aboutMovie

    
    init(dependencies: DetailViewModelDependencies, movieId : Int){
        self.viewModel = ViewModel (dependencies: dependencies, movieId: movieId)
        self.movieId = movieId
    }
    
    let movieId : Int

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .initial:
                ProgressView()
                    .onAppear{
                        viewModel.fetchMovie(movieId)
                    }
            case .loading:
                ProgressView()
            case .error:
                Text("error")
            case .finished:
                detail
            }
            
        }
//        .onReceive(viewModel.refreshSubject) { _ in
//            viewModel.fetchMovie(movieId) // Osvježava film kada primi signal za osvježavanje
//        }
     }
   
    
     var about : some View {
         VStack{
             Text("\(viewModel.movie?.overview ?? "")")
             Spacer()
         }
         .background{
             Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                 .ignoresSafeArea()
         }
     }

     var detail : some View {
         NavigationView{
             VStack{
                 ZStack {
                     WebImage(url: viewModel.movie?.backdropPathURL)
                         .resizable()
                         .frame(height: 210, alignment: .top)
                     
                     HStack{
                         let voteAverage = String (format: "%.1f" , viewModel.movie?.voteAverage ?? 0)
                         Image(systemName: "star")
                             .foregroundColor(Color(red: 1 , green: 0.52941176, blue: 0))
                         Text("\(voteAverage)")
                             .foregroundColor(Color(red: 1 , green: 0.52941176, blue: 0))
                     }
                         .padding(7)
                         .background(Color(red: 0.14509804, green: 0.15686275, blue: 0.21176471))
                         .cornerRadius(10)
                         .offset(x: 150, y: 80)
                     
                     VStack{
                         WebImage(url: viewModel.movie?.posterPathURL)
                             .resizable()
                             .cornerRadius(16)
                             .frame(width: 95, height: 120)
                             .offset(x: -130, y: 100)
                             .overlay(alignment: .bottomLeading){
                                 Text("\(viewModel.movie?.title ?? "")")
                                     .lineLimit(...2)
                                     .font(.title2.bold())
                                     .foregroundColor(.white)
                                     .offset(x:-30, y:100)
                             }
                     }
                 }
                 .padding(EdgeInsets(top: 0, leading: 0, bottom: 76.06, trailing: 0))
                 Spacer()
                 .background{
                        Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                            .ignoresSafeArea()
                    }
               
                HStack {
                    HStack{
                        Image(systemName: "calendar")
                            .frame(width: 12, height: 12)
                        if let movie = viewModel.movie{
                            Text(String(movie.releaseDate.prefix(4)))
                        }
                    }
                    Image(systemName: "minus")
                        .resizable()
                        .frame(width: 18, height: 3)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .rotationEffect(.degrees(90))
                        .foregroundColor(Color(red : 0.572549019607843, green : 0.572549019607843, blue : 0.615686274509804))
        
                    HStack{
                        Image(systemName: "clock")
                            .frame(width: 12, height: 12)
                        Text("\(viewModel.movie?.runTime ?? 0)")
                    }
                    Image(systemName: "minus")
                        .resizable()
                        .frame(width: 18, height: 3)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .rotationEffect(.degrees(90))
                        .foregroundColor(Color(red : 0.572549019607843, green : 0.572549019607843, blue : 0.615686274509804))
                    
                    HStack{
                        Image(systemName: "circle.square")
                            .frame(width: 12, height: 12)
                        Text("\(viewModel.movie?.genresName ?? "")")
                    }
                }
                .foregroundColor(Color(red : 0.572549019607843, green : 0.572549019607843, blue : 0.615686274509804))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0))
                 Spacer()
                 
                VStack{
                    HStack{
                        ForEach(ViewModel.description.allCases, id: \.rawValue) {type in
                            Text (type.rawValue)
                                .padding(.leading,10)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .background(alignment: .bottom, content: {
                                    if activeTab == type {
                                        Capsule()
                                            .fill(Color(red: 0.22745098, green: 0.24705882, blue: 0.27843137))
                                            .frame(height: 4)
                                            .padding(.horizontal, 5)
                                            .offset(y:15)
                                    }
                                })
                                .padding(5)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)){
                                        activeTab = type
                                    }
                                }
                        }
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 0))
                    Spacer()
                
                    if activeTab == .aboutMovie{
                        about
                            .foregroundColor(.white)
                            .padding()
                            .background{
                                Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                                    .ignoresSafeArea()
                            }
                    }
                    else if activeTab == .reviews {
                        
                        ReviewView(dependencies: viewModel.dependencies, movieId: viewModel.movie?.id ?? 0)
                            .foregroundColor(.white)
                    }
                    else if activeTab == .cast
                    {
                        CastView(dependencies: viewModel.dependencies, movieId: viewModel.movie?.id ?? 0)
                            .foregroundColor(.white)
                    }
                }
                 Spacer()
            }
             .frame(maxWidth: .infinity, maxHeight: .infinity)
             .background{
                Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                    .ignoresSafeArea()
            }
             
        }
         
         .navigationTitle("Detail")
         .navigationBarTitleDisplayMode(.inline)
         .background{
             Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                 .ignoresSafeArea()
         }
         .toolbar{
            let image1 = Image(systemName: "bookmark")
            let image2 = Image(systemName: "bookmark.fill")
            
            Button( viewModel.isSaved ? "\(image2)" : "\(image1)"){
                if viewModel.isSaved {
                    viewModel.remove(id: movieId)
                }
                else {
                    viewModel.add(id: movieId)
                }
            }
        }
    }
}
//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        DetailView(dependencies: AppDependenciesContainer(), movieId:)
//
//    }
//}

protocol DetailViewModelDependencies: ReviewViewModelDependencies, CastViewModelDependencies{
    var movieUseCase: MovieUseCase {get}
    var movieWatchListUseCase : MovieWatchListUseCase {get}
}

extension DetailView {
    final class ViewModel: ObservableObject {
        
        let dependencies: DetailViewModelDependencies
        
        @Published var viewState : ViewState = .initial
        @Published var movie : MovieData? = nil
        @Published var isSaved : Bool
        let movieId : Int
        let refreshSubject = RefreshManager.shared.refreshSubject
        
        init(dependencies: DetailViewModelDependencies, movieId : Int) {
            self.dependencies = dependencies
            self.movieId = movieId
            isSaved = dependencies.movieWatchListUseCase.isInWatchList(id: movieId)
        }
        
        private var subscriptions = Set<AnyCancellable>()
        
        enum ViewState {
            case initial
            case loading
            case error
            case finished
        }
        struct type : Identifiable, Hashable, Equatable{
            var id: UUID = UUID()
            var type: description
        }
        
        enum description: String, CaseIterable {
            case aboutMovie = "About Movie"
            case reviews = "Reviews"
            case cast = "Cast"
        }
        
        func add (id : Int){
            dependencies.movieWatchListUseCase.add(id: id)
            isSaved = true
        }

        
        func remove (id : Int){
            dependencies.movieWatchListUseCase.remove(id: id)
            isSaved = false
        }
        
        func fetchMovie(_ id : Int){
            viewState = .loading

            dependencies.movieUseCase.fetchMovie(id: id)
                .sink(receiveCompletion: { completion in
                    switch completion{
                    case .failure:
                //      print(error as! APIError)
                        self.viewState = .error
                    case .finished:
                        self.viewState = .finished
                    }
                }, receiveValue: { data in
                    self.movie = data
                //   print(data.posterPathURL)
                    self.viewState = .finished
                }
                )
                .store(in: &subscriptions)
        }
    }
}

