//
//  CreditsUseCase.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine

protocol CreditsUseCase {
    func fetchCredits (id: Int) -> AnyPublisher<[CastData], Error>
}

struct CastData: Identifiable {
    let id: Int
    let name: String
    let profilePath : String
    
    var profilePathURL : URL{
        return URL (string: "https://image.tmdb.org/t/p/w500\(profilePath)")!
    }
}
