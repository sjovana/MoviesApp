//
//  MovieWatchListUseCase.swift
//  MoviesApp
//
//  Created by Jovana Šubarić on 1.4.23..
//

import Foundation
import Combine

protocol MovieWatchListUseCase {
    func add (id : Int)
    func remove (id : Int)
    func isInWatchList(id : Int) -> Bool
}
