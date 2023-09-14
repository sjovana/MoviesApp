//
//  ReviewUseCase.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine

protocol ReviewUseCase {
    func fetchReview(id: Int) -> AnyPublisher<[ReviewData], Error>
}

struct ReviewData: Identifiable  {
    let id: String
    let author: String
    let avatarPath : String
    let raiting: Double
    let content: String
    
    var avatarPathURL : URL {
        return URL (string: "https://image.tmdb.org/t/p/w500\(avatarPath)")!
    }
}
