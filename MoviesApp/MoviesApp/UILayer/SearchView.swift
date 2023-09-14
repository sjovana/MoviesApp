//
//  SearchView.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 4.4.23..
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
import Combine

struct SearchView: View {
//    @State var searchText = ""
    @ObservedObject var viewModel : ViewModel

    
    init(dependencies: SearchViewModelDependencies){
        self.viewModel = ViewModel(dependencies: dependencies)
    }
    
    var body: some View {
        NavigationView{
            VStack {
                textFieldView
                Spacer()
                    
                HStack{
                    if viewModel.searchResults.isEmpty {
                        empty
                    }
                    else{
                        results
                    }
                }
                Spacer()
                
             
               
            }
            .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.inline)
            .background{
                Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                    .ignoresSafeArea()
            }
          
        }
    }
    var empty : some View {
        VStack{
            Image("Group-3")
                .resizable()
                .frame(width: 76, height: 76)
            Text("We Are Sorry, We Can")
                .font(.title.bold())
                .foregroundColor(.white)
            Text("Not Find The Movie :(")
                .foregroundColor(.white)
                .font(.title.bold())
            Text("")
            Text("Find your movie by Type title,")
                .font(.headline)
                .foregroundColor(.gray)
            Text("categories, years, etc")
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
    var results : some View {
        VStack{
            List {
                ForEach(viewModel.searchResults) { sr in
                    ZStack{
                        NavigationLink(destination: DetailView(dependencies: viewModel.dependencies, movieId: sr.id)) {
                            EmptyView()
                        }
                        .opacity(0)
                        .buttonStyle(PlainButtonStyle())
                        HStack{
                            SearchViewListCell(searchResult: sr)
                                
                        }
                    }
                    .listRowBackground(Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706))
                    }
            }
        }
        .background{
            Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                .ignoresSafeArea()
        }
        .scrollContentBackground(.hidden)
    }
    var textFieldView : some View {
            VStack{
                HStack{
                    TextField("Search", text: $viewModel.searchText, onCommit: {
                        viewModel.filterContent()
                    })
                        .foregroundColor(.white)
                        .padding()
                        .cornerRadius(16)
                        .onChange(of: viewModel.searchText){ newValue in
                                viewModel.fetch(searchTerm: newValue)
                        }
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(red: 0.40392157, green: 0.40784314, blue: 0.42745098))
                        .padding()
                    
                }
        
                Spacer()
            }
            .frame(height: 42)
        
    }
    struct SearchViewListCell : View {
        let searchResult : SearchResult
        var body: some View{
            VStack{
                HStack{
                    VStack{
                        WebImage(url: searchResult.posterPathURL)
                            .resizable()
                            .frame(width: 95, height: 120)
                            .cornerRadius(16)
                    }
                    VStack{
                        HStack{
                            Text("\(searchResult.title)")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        HStack{
                            Text("")
                        }
                        HStack{
                            let voteAverage = String (format: "%.1f" , searchResult.voteAverage)
                            Image(systemName: "star")
                                .foregroundColor(Color(red: 1 , green: 0.52941176, blue: 0))
                                .frame(width: 13, height: 12.5)
                            Text("\(voteAverage)")
                                .foregroundColor(Color(red: 1 , green: 0.52941176, blue: 0))
                                .font(.system(size: 12))
                            Spacer()
                        }
                        HStack{
                            Image(systemName: "calendar")
                                .frame(width: 11, height: 11)
                                .foregroundColor(.white)
                            Text(String(searchResult.releaseDate.prefix(4)))
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                    Spacer()
                }
               // .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            }
           
        }
    }

}
protocol SearchViewModelDependencies: DetailViewModelDependencies {
    var searchUseCase: SearchUseCase {get}
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(dependencies: AppDependenciesContainer())
    }
}
extension SearchView {
    final class ViewModel: ObservableObject {
        
        let dependencies: SearchViewModelDependencies
        
        @Published var viewState : ViewState = .finished
        @Published var searchResults = [SearchResult]()
        var all =  [SearchResult]()
        @Published var hasFailed = false
        @Published var searchText: String = ""
        
        private var subscriptions = Set<AnyCancellable>()
                
        init(dependencies: SearchViewModelDependencies) {
            self.dependencies = dependencies
        }
        
        enum ViewState {
            case initial
            case loading
            case finished
        }
        
        func fetch(searchTerm: String){
            viewState = .loading
            
            dependencies.searchUseCase.fetchMovie(for: searchTerm)
                .sink(receiveCompletion: {completion in
                    switch completion{
                    case .failure:
                        self.hasFailed = true
                    case .finished:
                        return
                    }
                }, receiveValue:{ results in
                    self.searchResults = results
                    self.viewState = .finished
                }
                )
                .store(in: &subscriptions)
        }
        var res : [SearchResult] {
            if searchText.isEmpty {
                return searchResults
            }
            else {
                return searchResults.filter {
                    $0.title.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        func filterContent() {

            var matching: [SearchResult] = []
             
                all.forEach { sr in
                    
                    let matchingResults = res.filter { $0.title.contains("\(sr.title)")}
                        if !matchingResults.isEmpty {
                            matching.append(sr)
                        }
                }
                self.searchResults = matching
        }
    }
}
