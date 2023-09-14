//
//  GetAllWatchListMovies.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 5.4.23..
//

import Foundation
import Combine

protocol GetAllWatchListMoviesUseCase {
    func fetchAllStoredMovieIds() -> [Int]
}
//struct wl : Identifiable {
//    let movies: MovieData
//    var id: Int? {
//        movies.id
//    }
//}
