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
        return viewController
    }
}
