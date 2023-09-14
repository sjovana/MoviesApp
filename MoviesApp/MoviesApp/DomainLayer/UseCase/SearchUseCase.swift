//
//  SearchUseCase.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 4.4.23..
//

import Foundation
import Combine

protocol SearchUseCase {
    func fetchMovie (for searchTerm: String) -> AnyPublisher<[SearchResult], Error>
}

struct SearchResult : Identifiable {
    
    let id : Int
    let title : String
    let posterPath: String
//    let runTime: Int
//    let genresName: String
    let releaseDate: String
    let voteAverage: Double
    
    var posterPathURL: URL {
        return URL (string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
    }
    
    
}
