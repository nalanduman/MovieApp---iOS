//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation

final class MovieListViewModel: BaseViewModel {
    private var movies: [MovieResult]?
    private var selectedMovieID: Int?
    private var page: Int = 1
    private var totalPages = 1
    private var isLoading = false
    private var searchText: String?
    private var viewSelection: MultipleViewSelectionEnum = .multiple {
        didSet {
            self.moviesCallback?()
        }
    }

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
    
    func setViewSelection(_ selection: MultipleViewSelectionEnum) {
        viewSelection = selection
    }
    
    func getViewSelection() -> MultipleViewSelectionEnum {
        viewSelection
    }
    
    func isMultipleSelection() -> Bool {
        viewSelection == .multiple
    }
    
    func changeMultipleSelectionState() {
        setViewSelection(isMultipleSelection() ? .single : .multiple)
    }
    
    func setIncreasePage() {
        page += 1
    }
    
    func resetPage() {
        movies = nil
        isLoading = false
        page = 1
    }
    
    func paginationMovies() {
        if !(searchText?.isEmpty ?? true) {
            getSearchMoviesPaginating()
        } else {
            getPopularMoviesPaginating()
        }
    }
    func getPopularMoviesPaginating() {
        guard !isLoading, page <= totalPages else { return }
        getPopularMovies(with: true)
    }
    
    func getSearchMoviesPaginating() {
        guard !isLoading, page <= totalPages else { return }
        searchMovies(with: searchText ?? "", isPaginating: true)
    }
}

// MARK: - Service Methods
extension MovieListViewModel {
    func getPopularMovies(with isPaginating: Bool = false) {
        searchText = ""
        guard !isLoading else { return }
        isLoading = true
        NetworkManager.shared.getPopularMovies(page: page) { response in
            self.isLoading = false
            guard let response, let results = response.results, results.count > 0 else { return }
            self.totalPages = response.totalPages ?? 1
            if self.movies != nil {
                self.movies?.append(contentsOf: results)
            } else {
                self.movies = results
            }
            self.moviesCallback?()
            self.setIncreasePage()
        }
    }
    
    func searchMovies(with text: String, isPaginating: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        NetworkManager.shared.searchMovie(text, page: page) { response in
            self.isLoading = false
            guard let response, let results = response.results, results.count > 0 else { return }
            self.totalPages = response.totalPages ?? 1
            self.searchText = text
            if self.movies != nil {
                self.movies?.append(contentsOf: results)
            } else {
                self.movies = results
            }
            self.moviesCallback?()
            self.setIncreasePage()
        }
    }
}
