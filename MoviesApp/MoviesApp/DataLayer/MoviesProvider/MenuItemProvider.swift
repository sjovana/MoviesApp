//
//  MenuItemProvider.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 13.8.23..
//

import Foundation
import Combine

//final class MenuItemProvider: MenuItemUseCase{
//    let webService: WebService
//    
//    init(webService: WebService)
//    {
//        self.webService = webService
//    }
//    
//    func fetchMovie(id : Int) -> AnyPublisher<MenuItemm, Error> {
//        let request = APIRequest(endpoint: .movie(id))
//        
//        guard let urlRequest = try? request.getURLRequest() else {
//            return Fail(error: URLError.urlMalformed)
//                .eraseToAnyPublisher()
//        }
//        
//        return Just(urlRequest)
//            .flatMap { request -> AnyPublisher<MenuItemDTO, Error> in
//                self.webService.execute(request)
//            }
//            .map { dto in
//                dto.menuItemResponse
//            }
//            .eraseToAnyPublisher()
//    }
//}
//
//struct MenuItemDTO: Decodable{
//    let id: Int
//    let posterPath : String?
//    let backdropPath : String?
//    let title: String?
//    let voteAverage : Double?
//    let runtime: Int?
//    let releaseDate : String?
//    let genres : [genresDTO]
//    let overview: String?
//    
//    var menuItemResponse: MenuItemm{
//       MenuItemm(id: id ,
//                 posterPath: posterPath ?? "" ,
//                 title: title ?? "",
//                 voteAverage: voteAverage ?? 0.0,
//                 runTime: runtime ?? 0,
//                 releaseDate: releaseDate ?? "",
//                 genresName: genres.first?.name ?? "",
//                 backdropPath: backdropPath ?? "",
//                 overview: overview ?? ""
//       )
//    }
//
//        private enum CodingKeys: String, CodingKey {
//            case id, title, runtime, overview, genres
//            case posterPath = "poster_path"
//            case backdropPath = "backdrop_path"
//            case releaseDate = "release_date"
//            case voteAverage = "vote_average"
//        }
//    
//    struct genresDTO: Decodable{
//        let name: String
//    }
//}
//
