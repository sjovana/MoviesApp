//
//  UpcomingProvider.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine

final class UpcomingProvider: UpcomingUseCase {
    let webService: WebService
    
    init(webService: WebService)
    {
        self.webService = webService
    }
    
    func fetchUpcoming() -> AnyPublisher<[UpcomingData], Error> {
        let request = APIRequest(endpoint: .upcoming)
        
        guard let urlRequest = try? request.getURLRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<UpcomingDTO, Error> in
                self.webService.execute(request)
            }
            .map { dto in
                dto.entity
            }
            .eraseToAnyPublisher()
    }
}

struct UpcomingDTO: Decodable{
    let results : [ResultsDTO]
    
    var entity: [UpcomingData]{
        results.map {dto in
            UpcomingData(
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
