//
//  NowPlayingUseCase.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine

protocol NowPlayingUseCase {
    func fetchNowPlaying() -> AnyPublisher<[NowPlayingData], Error>
}

struct NowPlayingData: Identifiable, Equatable{
    let id: Int
    let posterPath: String
    
    var posterPathURL : URL {
        return URL (string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
    }
}
