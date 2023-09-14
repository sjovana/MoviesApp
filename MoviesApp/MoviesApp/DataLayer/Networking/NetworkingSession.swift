//
//  NetworkingSession.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine

protocol NetworkSession {
    func perform(with request: URLRequest) -> AnyPublisher<Data, Error>
}

class DataNetworkSession: NetworkSession {
    func perform(with request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                  
                    let error = try? JSONDecoder().decode(ErrorDTO.self, from: data)
                
                    throw APIError.unknown(reason: error?.message ?? "")
                }
                return data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum APIError: Error {
    case dataParseFailed
    case unknown(reason: String)
}

struct ErrorDTO: Codable {
    let message: String
}

