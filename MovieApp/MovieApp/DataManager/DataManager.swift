//
//  DataManager.swift
//  MovieApp
//
//  Created by Nalan Duman on 13.12.2024.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    
    var favoriteMovies: [Int]? = [] {
        didSet {
            UserDefaults.standard.set(favoriteMovies, forKey: "favoriteMovies")
            UserDefaults.standard.synchronize()
        }
    }
}
