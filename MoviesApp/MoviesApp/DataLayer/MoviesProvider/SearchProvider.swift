//
//  SearchProvider.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 4.4.23..
//

import Foundation
import Combine

final class SearchProvider: SearchUseCase {
    let webService : WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func fetchMovie(for searchTerm: String) -> AnyPublisher<[SearchResult], Error> {
        let request = APIRequest(endpoint: .search(searchTerm))
        
        guard let urlRequest = try? request.getURLRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<SearchDTO, Error> in
                self.webService.execute(request)
            }
            .map { dto in
                dto.entity
            }
            .eraseToAnyPublisher()
    }
}

struct SearchDTO: Decodable {
    let results : [ResultsDTO]
    
    var entity: [SearchResult]{
        results.map {dto in
            SearchResult(id: dto.id,
                         title: dto.title,
                         posterPath: dto.posterPath,
                         releaseDate: dto.releaseDate,
                         voteAverage: dto.voteAverage)
        }
    }
    struct ResultsDTO: Decodable{
        let id: Int
        let posterPath : String
        let releaseDate : String
        let title : String
        let voteAverage : Double
        
        enum CodingKeys: String, CodingKey{
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case id
            case title
            case voteAverage = "vote_average"
        }
    }
}
