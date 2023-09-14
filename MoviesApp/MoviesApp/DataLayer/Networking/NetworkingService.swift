//
//  NetworkingService.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 28.3.23..
//

import Foundation
import Combine
import KeychainAccess

protocol WebService {
    func execute<D>(_ request: URLRequest) -> AnyPublisher<D, Error>  where D : Decodable
}

class NetworkService: WebService {
    let networkSession: NetworkSession
    let decoder =  JSONDecoder()

    init(
        networkSession: NetworkSession
    ){
        self.networkSession = networkSession
    }
    
    func execute<D>(_ request: URLRequest) -> AnyPublisher<D, Error> where D : Decodable {

        return networkSession.perform(with: request)
            .decode(type: D.self, decoder: decoder)
            .mapError { error in
                if let error = error as? DecodingError {
                    var errorToReport = error.localizedDescription
                    switch error {
                    case .dataCorrupted(let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) - (\(details))"
                    case .keyNotFound(let key, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
                    case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
                    @unknown default:
                        break
                    }
                    return APIError.unknown(reason: errorToReport)
                }  else {
                    return error
                }
            }
            .eraseToAnyPublisher()
    }
}

//extension URLRequest {
//    enum Headers: String{
//        case accept = "Accept"
//        case authorization = "token"
//        case contentType = "content-type"
//    }
//}
//
//private extension URLRequest {
//    mutating func setAuthorization (_ token: String, contentType: String?){
//        self.setValue("*/*", forHTTPHeaderField: URLRequest.Headers.accept.rawValue)
//        self.setValue(contentType ?? "application/json; charset=utf-8", forHTTPHeaderField: URLRequest.Headers.contentType.rawValue)
//        self.setValue(token, forHTTPHeaderField: URLRequest.Headers.authorization.rawValue)
//    }
//}
