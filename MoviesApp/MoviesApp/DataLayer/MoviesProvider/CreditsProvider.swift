//
//  CreditsProvider.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine

final class CreditsProvider: CreditsUseCase{
    let webService: WebService
    
    init(webService: WebService)
    {
        self.webService = webService
    }
    
    func fetchCredits (id : Int) -> AnyPublisher<[CastData], Error> {
        let request = APIRequest(endpoint: .credits(id))
        
        guard let urlRequest = try? request.getURLRequest() else {
            return Fail(error: URLError.urlMalformed)
                .eraseToAnyPublisher()
        }
        
        return Just(urlRequest)
            .flatMap { request -> AnyPublisher<CastDTO, Error> in
                self.webService.execute(request)
            }
            .map { dto in
                dto.castResponse
            }
            .eraseToAnyPublisher()
    }
}

struct CastDTO: Decodable{

    let cast : [CastDTO]

    var castResponse : [CastData] {
        cast.map { dto in
            CastData(id: dto.id,
                     name: dto.name,
                     profilePath: dto.profilePath ?? "")
        }
    }
    
    struct CastDTO : Decodable{
        let id : Int
        let name : String
        let profilePath : String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case profilePath = "profile_path"
        }
    }
}
