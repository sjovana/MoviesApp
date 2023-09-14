//
//  APIRequest.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation

struct APIRequest {
    let API_KEY = "128a1b484673ca9e6de6b24be55134a6"
    let baseURL : String = "https://api.themoviedb.org"
    let endpoint: Endpoint

    func getURLRequest() throws -> URLRequest{
        let url = baseURL + "/" + endpoint.version + "/" + endpoint.path + "api_key=\(API_KEY)" + endpoint.parameters
        
        guard let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else{
            throw URLError.urlMalformed
        }
        return URLRequest(url: url)
    }
}

extension APIRequest {
    enum Endpoint {
        case nowPlaying
        case upcoming
        case topRated
        case popular
        case movie (Int)
        case reviews (Int)
        case credits (Int)
        case search (String)
        
        
        var version : String {
            "3"
        }
        
        var path: String {
            
            switch self {
            case .nowPlaying:
                return "movie/now_playing?"
            case .popular:
                return "movie/popular?"
            case .topRated:
                return "movie/top_rated?"
            case .upcoming:
                return "movie/upcoming?"
            case .movie(let movieId):
                return "movie/\(movieId)?"
            case .reviews(let movieId):
                return "movie/\(movieId)/reviews?"
            case .credits(let movieId):
                return("movie/\(movieId)/credits?")
            case .search:
                return "search/movie?"
            }
        }
        
        var parameters: String {
            switch self {
            case .nowPlaying, .popular, .topRated, .upcoming:
                return "&language=en-US&page=1"
            case .movie, .credits:
                return "&language=en-US"
            case .reviews:
                return "&language=en-US&page=1"
            case .search(let result):
                return "&query=\(result)&page=1"
                
            }
        }
    }
}

enum URLError: Error{
    case urlMalformed
}

