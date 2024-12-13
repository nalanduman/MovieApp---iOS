//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation

final class MovieDetailViewModel: BaseViewModel {
    private var movie: MovieDetailResponseModel?
    
    func getMovieData() -> MovieDetailResponseModel? {
        guard let movie = movie else { return nil }
        return movie
    }
    
    func getMovie(with id: Int) {
        NetworkManager.shared.getMovie(id) { response in
            guard let response else { return }
            self.movie = response
        }
    }
}
