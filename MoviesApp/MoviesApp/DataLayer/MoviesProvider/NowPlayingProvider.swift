//
//  NowPlayingProvider.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine

final class NowPlayingProvider: NowPlayingUseCase{
    let webService: WebService
    
    init(webService: WebService)
    {
        self.webService = webService
    }
    
    func fetchNowPlaying() -> AnyPublisher<[NowPlayingData], Error> {
        let request = APIRequest(endpoint: .nowPlaying)
        
        guard let urlRequest = try? request.getURLRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<NowPlayingDTO, Error> in
                self.webService.execute(request)
            }
            .map { dto in
                dto.entity
            }
            .eraseToAnyPublisher()
    }
}

struct NowPlayingDTO: Decodable{
    let results : [ResultsDTO]
    
    var entity: [NowPlayingData]{
        results.map {dto in
            NowPlayingData(
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

