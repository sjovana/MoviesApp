//
//  ReviewView.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import SwiftUI
import Combine
import SDWebImage
import SDWebImageSwiftUI


struct ReviewView: View {
    @ObservedObject var viewModel : ViewModel
    
    init(dependencies: ReviewViewModelDependencies, movieId: Int) {
        self.viewModel = ViewModel(dependencies: dependencies)
        self.movieId = movieId
    }
    let movieId : Int
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .initial:
                ProgressView()
                    .onAppear{
                        viewModel.fetchReview(movieId)
                    }
            case .loading:
                ProgressView()
            case .error:
                Text("error")
            case .finished:
                review
            }
        }
    }
    
    var review : some View {
        VStack {
            ScrollView{
                ForEach(viewModel.review){ rew in
                    reviewCell(data: rew)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{
            Color(red: 0.11764706, green: 0.11764706, blue: 0.11764706)
                .ignoresSafeArea()
        }
    }
    
    struct reviewCell : View {
        let data: ReviewData
        
        var body: some View{
                VStack{
                        HStack{
                            VStack{
                                WebImage(url: data.avatarPathURL)
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .clipShape(Circle())
//                                    .overlay{
//                                        Circle()
//                                    }
                                let voteAverage = String (format: "%.1f" , data.raiting)
                                
                                Text("\(voteAverage)")
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 5))
                            
                            HStack{
                                VStack{
                                    HStack{
                                        Text("\(data.author)")
                                            .font(.headline.bold())
                                        Spacer()
                                    }
                                    HStack{
                                        Text("")
                                    }
                                    
                                    Text("\(data.content)")
                                }
                            }
                        }
                      
                }
            HStack{
                Text("")
            }
            
        }
    }
}

//struct ReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewView(dependencies: AppDependenciesContainer)
//    }
//}
protocol ReviewViewModelDependencies {
    var reviewUseCase: ReviewUseCase {get}
}
extension ReviewView {
    final class ViewModel: ObservableObject {
        
        let dependencies: ReviewViewModelDependencies
        
        @Published var viewState : ViewState = .initial
        @Published var review = [ReviewData]()
        
        private var subscriptions = Set<AnyCancellable>()
        
        init(dependencies: ReviewViewModelDependencies) {
            self.dependencies = dependencies
        }
        
        enum ViewState {
            case initial
            case loading
            case error
            case finished
        }
        
        func fetchReview(_ id: Int){
            viewState = .loading

            dependencies.reviewUseCase.fetchReview(id: id)
                .sink(receiveCompletion: { completion in
                    switch completion{
                    case .failure (let error):
                        print(error as! APIError)
                        self.viewState = .error
                    case .finished:
                        self.viewState = .finished
                    }

                }, receiveValue: { data in
                    self.review = data
                    print(data)
                    self.viewState = .finished
                    
                }
                )
                .store(in: &subscriptions)
             
            
        }
    }
}

