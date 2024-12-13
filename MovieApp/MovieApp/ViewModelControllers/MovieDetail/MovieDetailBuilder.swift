//
//  MovieDetailBuilder.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation
import UIKit

final class MovieDetailBuilder {
    class func make(movieId: Int) -> MovieDetailViewController {
        let viewController = UIStoryboard.instantiateViewController(.movieDetail, MovieDetailViewController.self)
        viewController.viewModel.getMovie(with: movieId)
        let likedMovie = DataManager.shared.favoriteMovies?.filter({ $0 == movieId }).count ?? 0 > 0
        viewController.viewModel.setStarStatus(likedMovie ? .liked : .unliked)
        return viewController
    }
}
