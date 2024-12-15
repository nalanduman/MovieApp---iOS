//
//  DataManager.swift
//  MovieApp
//
//  Created by Nalan Duman on 13.12.2024.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    
    var favoriteMovies: [Int]? {
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue),
                                      forKey: "favoriteMovies")
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: "favoriteMovies") else { return [] }
            return (try? PropertyListDecoder().decode([Int].self, from: data)) ?? .init()
        }
    }
}
