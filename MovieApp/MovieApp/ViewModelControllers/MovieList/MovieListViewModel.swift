//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation

final class MovieListViewModel: BaseViewModel {
    private var defaultMovies: [MovieResult]?
    private var movies: [MovieResult]?
    private var selectedMovieID: Int?
    
    var moviesCallback: VoidCallback?

    func getMovies() -> [MovieResult] {
        guard let movies else { return .init() }
        return movies
    }

    func getMovie(at index: Int) -> MovieResult? {
        guard let movies else { return nil }
        return movies[index]
    }
    
    func getSelectedMovieID() -> Int {
        guard let selectedMovieID else { return 0 }
        return selectedMovieID
    }
    
    func setSelectedMovieID(at index: Int) {
        guard let movie = getMovie(at: index) else { return }
        selectedMovieID = movie.id
    }
    
    func resetSearchList() {
        movies = defaultMovies
        moviesCallback?()
    }
    
    func getPopularMovies() {
        NetworkManager.shared.getPopularMovies { response in
            guard let response, let results = response.results, results.count > 0 else { return }
            self.defaultMovies = results
            self.movies = results
            self.moviesCallback?()
        }
    }
    
    func searchMovies(with text: String) {
        NetworkManager.shared.searchMovie(text) { response in
            guard let response, let results = response.results, results.count > 0 else { return }
            self.movies = results
            self.moviesCallback?()
        }
    }
}
