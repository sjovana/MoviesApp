//
//  PopularProvider.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine

final class PopularProvider: PopularUseCase {
    
    let webService: WebService
    
    init(webService: WebService)
    {
        self.webService = webService
    }
    
    func fetchPopular() -> AnyPublisher<[PopularData], Error> {
        let request = APIRequest(endpoint: .popular)
        
        guard let urlRequest = try? request.getURLRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<PopularDTO, Error> in
                self.webService.execute(request)
            }
            .map { dto in
                dto.entity
            }
            .eraseToAnyPublisher()
    }
}
struct PopularDTO: Decodable{
    let results : [ResultsDTO]
    
    var entity: [PopularData]{
        results.map {dto in
            PopularData(
                id: dto.id,
                posterPath: dto.posterPath)
        }
    }

    struct ResultsDTO: Decodable{
        let id: Int
        let posterPath : String
        
        enum CodingKeys: String, CodingKey{
            case id
            case posterPath = "poster_path"
        }
    }
}
