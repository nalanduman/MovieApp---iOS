//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation
import UIKit

final class MovieDetailViewController: BaseViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!

    lazy var viewModel: MovieDetailViewModel = {
        return MovieDetailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        movieNameLabel.text = viewModel.getMovieData().title
        movieDescriptionLabel.text = viewModel.getMovieData().overview
        voteCountLabel.text = viewModel.getMovieData().voteCount?.string
        if let posterPath = viewModel.getMovieData().posterPath {
            posterImageView.loadImage(fromURL: posterPath.toPosterUrl)
        }
    }
}
