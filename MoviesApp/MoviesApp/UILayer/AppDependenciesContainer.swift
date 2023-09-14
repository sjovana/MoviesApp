//
//  AppDependenciesContainer.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import SwiftUI
import Combine


final class AppDependenciesContainer : MoviesViewModelDependencies, HomeViewModelDependencies, WatchListViewModelDependencies, SearchViewModelDependencies, DetailViewModelDependencies, ActionDependencies, HomeWithSideMenuDependencies{
 
    
    
    lazy var refreshSubject: AnyPublisher<Void, Never> = {
        return PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    }()
 
    
    let webService = NetworkService(networkSession: DataNetworkSession())
    let userDefaults : StorageProviderProtocol = UserDefaultsProvider()
    
    lazy var nowPlayingUseCase: NowPlayingUseCase = NowPlayingProvider(webService: webService)
    lazy var upcomingUseCase: UpcomingUseCase = UpcomingProvider(webService: webService)
    lazy var popularUseCase: PopularUseCase = PopularProvider(webService: webService)
    lazy var topRatedUseCase: TopRatedUseCase = TopRatedProvider(webService: webService)
    lazy var movieUseCase: MovieUseCase = MovieProvider(webService: webService)
    lazy var reviewUseCase: ReviewUseCase = ReviewProvider(webService: webService)
    lazy var creditsUseCase: CreditsUseCase = CreditsProvider(webService: webService)
    lazy var searchUseCase : SearchUseCase = SearchProvider(webService: webService)
    lazy var movieWatchListUseCase : MovieWatchListUseCase = WatchListProvider(userDefaults: userDefaults)
    lazy var getAllWatchListMoviesUseCase : GetAllWatchListMoviesUseCase = WatchListProvider(userDefaults: userDefaults)
}

