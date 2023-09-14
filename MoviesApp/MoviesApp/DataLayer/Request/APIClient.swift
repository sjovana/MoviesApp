//
//  APIClient.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 13.8.23..
//

import Combine
import Foundation

struct APIClient {
    static func login(email: String, password: String) -> AnyPublisher<String, Error> {
        let loginURL = URL(string: "http://127.0.0.1:80/api/login")!
        
        let body = ["email": email, "password": password]
        let jsonData = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data -> String in
                guard let token = String(data: data, encoding: .utf8) else {
                    throw DecodingError.dataCorrupted(.init(codingPath: [],
                                                             debugDescription: "Could not decode data"))
                }
                return token
            }
            .eraseToAnyPublisher()
    }
    static func register(name: String, email: String, password: String) -> AnyPublisher<String, Error> {
        let registerURL = URL(string: "http://127.0.0.1:8000/api/register")! // Promenite URL prema stvarnom API-ju

        let body = ["name": name, "email": email, "password": password]
        let jsonData = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data -> String in
                guard let token = String(data: data, encoding: .utf8) else {
                    throw DecodingError.dataCorrupted(.init(codingPath: [],
                                                             debugDescription: "Could not decode data"))
                }
                return token
            }
            .eraseToAnyPublisher()
    }
}
