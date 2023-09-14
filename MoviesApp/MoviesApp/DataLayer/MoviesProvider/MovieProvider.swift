//
//  MovieProvider.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine

final class MovieProvider: MovieUseCase{
    let webService: WebService
    
    init(webService: WebService)
    {
        self.webService = webService
    }
    
    func fetchMovie(id : Int) -> AnyPublisher<MovieData, Error> {
        let request = APIRequest(endpoint: .movie(id))
        
        guard let urlRequest = try? request.getURLRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<MovieDTO, Error> in
                self.webService.execute(request)
            }
            .map { dto in
                dto.movieResponse
            }
            .eraseToAnyPublisher()
    }
}

struct MovieDTO: Decodable{
    let id: Int
    let posterPath : String?
    let backdropPath : String?
    let title: String?
    let voteAverage : Double?
    let runtime: Int?
    let releaseDate : String?
    let genres : [genresDTO]
    let overview: String?
    
    var movieResponse: MovieData{
       MovieData(id: id ,
                 posterPath: posterPath ?? "" ,
                 title: title ?? "",
                 voteAverage: voteAverage ?? 0.0,
                 runTime: runtime ?? 0,
                 releaseDate: releaseDate ?? "",
                 genresName: genres.first?.name ?? "",
                 backdropPath: backdropPath ?? "",
                 overview: overview ?? ""
       )
    }

        private enum CodingKeys: String, CodingKey {
            case id, title, runtime, overview, genres
            case posterPath = "poster_path"
            case backdropPath = "backdrop_path"
            case releaseDate = "release_date"
            case voteAverage = "vote_average"
        }
    
    struct genresDTO: Decodable{
        let name: String
    }
}
