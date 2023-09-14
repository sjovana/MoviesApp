//
//  UserDefaultsProvider.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 1.4.23..
//

import Foundation

protocol StorageProviderProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func object(forKey defaultName: String) -> Any?
}

final class UserDefaultsProvider : StorageProviderProtocol {
    
    let userDefaults = UserDefaults.standard

    func set(_ value: Any?, forKey defaultName: String) {
        userDefaults.set(value, forKey: defaultName)
    }
    
    func object(forKey defaultName: String) -> Any? {
        userDefaults.object(forKey: defaultName)
    }
}
