//
//  TopRatedUseCase.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine

protocol TopRatedUseCase {
    func fetchTopRated() -> AnyPublisher<[TopRatedData], Error>
}

struct TopRatedData: Identifiable {
    let id : Int
    let posterPath : String
    
    var posterPathURL : URL {
        return URL (string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
    }
}
