//
//  CastView.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import SwiftUI
import Combine
import SDWebImage
import SDWebImageSwiftUI

struct CastView: View {
    @ObservedObject var viewModel : ViewModel
    
    let movieId : Int
    
    init(dependencies: CastViewModelDependencies, movieId: Int) {
        self.viewModel = ViewModel(dependencies: dependencies)
        self.movieId = movieId
    }
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .initial:
                ProgressView()
                    .onAppear{
                        viewModel.fetchCredits(movieId)
                    }
            case .loading:
                ProgressView()
            case .error:
                Text("error")
            case .finished:
               castGrid
            }
  
        }
    }
    var castGrid :  some View  {
        VStack{
            let columns = Array(repeating: GridItem(.flexible()), count: 2)
            ScrollView{
                LazyVGrid(columns: columns){
                    ForEach(viewModel.credits) { credit in
                        castCell(data: credit)
                    }
                }
            }
        }
    }
    struct castCell : View {
        let data : CastData

        var body: some View {
            
            VStack{
                WebImage(url: data.profilePathURL)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                Text("\(data.name)")
                
            }.padding()
        }
    }
    
    
}

//struct CastView_Previews: PreviewProvider {
//    static var previews: some View {
//        CastView()
//    }
//}
protocol CastViewModelDependencies {
    var creditsUseCase: CreditsUseCase {get}
}
extension CastView {
    final class ViewModel : ObservableObject {
        
        let dependencies: CastViewModelDependencies
        
        @Published var viewState : ViewState = .initial
        @Published var credits = [CastData]()
        
        private var subscriptions = Set<AnyCancellable>()
        
        init(dependencies: CastViewModelDependencies) {
            self.dependencies = dependencies
        }
        enum ViewState {
            case initial
            case loading
            case error
            case finished
        }
        
        func fetchCredits (_ id: Int){
            viewState = .loading

            dependencies.creditsUseCase.fetchCredits(id: id)
                .sink(receiveCompletion: { completion in
                    switch completion{
                    case .failure (let error):
                    //    print(error.localizedDescription)
                        self.viewState = .error
                    case .finished:
                        self.viewState = .finished
                    }

                }, receiveValue: { data in
                    self.credits = data
                    self.viewState = .finished
                    
                }
                )
                .store(in: &subscriptions)
             
            
        }
    }
}
