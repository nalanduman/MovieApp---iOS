//
//  MovieListBuilder.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation
import UIKit

final class MovieListBuilder {
    class func make() -> MovieListViewController {
        let viewController = UIStoryboard.instantiateViewController(.movieList, MovieListViewController.self)
        viewController.viewModel.getPopularMovies()
        return viewController
    }
}
