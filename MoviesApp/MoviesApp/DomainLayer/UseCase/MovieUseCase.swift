//
//  MovieUseCase.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine


protocol MovieUseCase {
    func fetchMovie(id : Int) -> AnyPublisher<MovieData, Error>
}

struct MovieData: Identifiable, Encodable, Hashable {
    let id: Int
    let posterPath: String
    let title: String
    let voteAverage: Double
    let runTime: Int
    let releaseDate: String
    let genresName: String
    let backdropPath: String
    let overview: String
    
    var backdropPathURL : URL{
        return URL (string: "https://image.tmdb.org/t/p/w500\(backdropPath)")!
    }
    
    var posterPathURL: URL {
        return URL (string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
    }
    


}
