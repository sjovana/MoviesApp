//
//  TopRatedProvider.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine


final class TopRatedProvider: TopRatedUseCase{
    let webService: WebService
    
    init(webService: WebService)
    {
        self.webService = webService
    }
    
    func fetchTopRated() -> AnyPublisher<[TopRatedData], Error> {
        let request = APIRequest(endpoint: .topRated)
        
        guard let urlRequest = try? request.getURLRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<TopRatedDTO, Error> in
                self.webService.execute(request)
            }
            .map { dto in
                dto.entity
            }
            .eraseToAnyPublisher()
    }
}

struct TopRatedDTO: Decodable{
    let results : [ResultsDTO]
    
    var entity: [TopRatedData]{
        results.map {dto in
            TopRatedData(
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
