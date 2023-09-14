//
//  ReviewProvider.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine

final class ReviewProvider : ReviewUseCase{
    let webService: WebService
    
    init(webService: WebService)
    {
        self.webService = webService
    }
    
    func fetchReview(id : Int) -> AnyPublisher<[ReviewData], Error> {
        let request = APIRequest(endpoint: .reviews(id))
        
        guard let urlRequest = try? request.getURLRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<ReviewDTO, Error> in
                self.webService.execute(request)
            }
            .map { dto in
                dto.reviewResponse
            }
            .eraseToAnyPublisher()
    }
}

struct ReviewDTO: Decodable{
    let results : [resultsDTO]
    
    var reviewResponse : [ReviewData] {
        results.map { dto in
            ReviewData( id: dto.id,
                        author: dto.author ?? "",
                        avatarPath: dto.authorDetails?.avatarPath ?? "",
                        raiting: dto.authorDetails?.rating ?? 0,
                        content: dto.content ?? "")
        }
    }
        
    struct resultsDTO : Decodable {
        let author : String?
        let authorDetails : detailsDTO?
        let content : String?
        let id : String
        
        enum CodingKeys : String, CodingKey {
            case author
            case authorDetails = "author_details"
            case content
            case id
        }
        
        struct detailsDTO : Decodable {
            let avatarPath : String?
            let rating : Double?
            
            enum CodingKeys : String, CodingKey {
                case rating
                case avatarPath = "avatar_path"
            }
        }
    }
}

