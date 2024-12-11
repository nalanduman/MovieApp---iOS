//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation

final class MovieListViewModel: BaseViewModel {
    private var movies: [MovieResult] = []
    
    func getPopularMovies() {
        NetworkManager.shared.getPopularMovies { response in
            guard let response, let results = response.results, results.count > 0 else { return }
            self.movies = results
        }
    }
}
