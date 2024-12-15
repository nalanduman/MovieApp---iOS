//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation

final class MovieDetailViewModel: BaseViewModel {
    private var movie: MovieDetailResponseModel?
    private var starStatus: StarStatusEnum = .unliked {
        didSet {
            updatedStarStatus?()
        }
    }

    var reloadData: VoidCallback?
    var reloadView: VoidCallback?
    var updatedStarStatus: VoidCallback?

    func getMovieData() -> MovieDetailResponseModel? {
        guard let movie = movie else { return nil }
        return movie
    }
    
    func setStarStatus(_ starStatus: StarStatusEnum) {
        self.starStatus = starStatus
    }
    
    func getStarStatus() -> StarStatusEnum {
        return starStatus
    }
    
    func changeStarStatus() {
        starStatus = starStatus.changeStatus(starStatus)
    }
}

// MARK: - Service Methods
extension MovieDetailViewModel {
    func getMovie(with id: Int) {
        NetworkManager.shared.getMovie(id) { response in
            guard let response else { return }
            self.movie = response
            self.reloadData?()
        }
    }
    
    func setTextToImageUpload(base64str: String) {
        NetworkManager.shared.sendTextToImageRequest(prompt: starStatus.rawValue, base64str: base64str, inputImage: false) { response in
            guard let response, response.result ?? false else { return }
            self.reloadView?()
        }
    }
    
    func setFavoritedMovie(with movieId: Int) {
        if starStatus == .unliked {
            guard let id = DataManager.shared.favoriteMovies?.firstIndex(of: movieId) else { return }
            DataManager.shared.favoriteMovies?.remove(at: id)
        } else {
            DataManager.shared.favoriteMovies?.append(movieId)

        }
    }
}
