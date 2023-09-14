//
//  WatchListProvider.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 1.4.23..
//

import Foundation
import Combine

final class WatchListProvider: MovieWatchListUseCase, GetAllWatchListMoviesUseCase {
    
    let userDefaults: StorageProviderProtocol
    let refreshSubject = RefreshManager.shared.refreshSubject

    init (userDefaults: StorageProviderProtocol ){
        self.userDefaults = userDefaults
    }
    
    private let watchListIdsKey = "watchListMovies"
    
    func fetchAllStoredMovieIds() -> [Int] {
        let storedMovieIds = userDefaults.object(forKey: watchListIdsKey)
        
        if let storedMovieIdsArray = storedMovieIds as? [Int] {
            return storedMovieIdsArray
        }
        else {
            return []
        }
        
    }
    
    func add(id : Int) {
        let storedMovieIds = userDefaults.object(forKey: watchListIdsKey)
        
        if var storedMovieIdsArray = storedMovieIds as? [Int] {
            storedMovieIdsArray.append(id)
            userDefaults.set(storedMovieIdsArray, forKey: watchListIdsKey)
        }
        else {
            userDefaults.set([id], forKey: watchListIdsKey)
        }
        refreshSubject.send()
    }
    
    func remove(id: Int) {
        let storedMovieIds = userDefaults.object(forKey: watchListIdsKey)
        
        if var storedMovieIdsArray = storedMovieIds as? [Int], storedMovieIdsArray.contains(id) {
            guard let index = storedMovieIdsArray.firstIndex(of: id) else {return}
            storedMovieIdsArray.remove(at: index)
            userDefaults.set(storedMovieIdsArray, forKey: watchListIdsKey)
        }
        refreshSubject.send()
     
    }
    
    func isInWatchList(id: Int) -> Bool {
        let storedMovieIds = userDefaults.object(forKey: watchListIdsKey)
        
        guard let array = storedMovieIds as? [Int] else {
            return false
        }
    
        let isInArray = array.contains(id)
        return isInArray
    }
}
