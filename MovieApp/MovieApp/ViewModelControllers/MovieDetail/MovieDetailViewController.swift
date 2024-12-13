//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation
import UIKit

enum StarStatus {
    case liked
    case unliked
    
    var icon: UIImage? {
        switch self {
        case .liked:
            return UIImage(systemName: "star.fill")
        case .unliked:
            return UIImage(systemName: "star")
        }
    }
    
    mutating func changeStatus(_ status: StarStatus) -> StarStatus {
        status == .liked ? .unliked : .liked
    }
}

protocol MovieDetailViewControllerProtocol: AnyObject {
    func updatedMovieStar(at id: Int)
}

extension MovieDetailViewControllerProtocol {
    func updatedMovieStar(at id: Int) { }
}

final class MovieDetailViewController: BaseViewController {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieDescriptionLabel: UILabel!
    @IBOutlet private weak var voteCountLabel: UILabel!
    
    private var starStatus: StarStatus = .unliked {
        didSet {
            updateStarStatus()
        }
    }

    weak var delegate: MovieDetailViewControllerProtocol?
    
    lazy var viewModel: MovieDetailViewModel = {
        return MovieDetailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUI()
    }
    
    private func setup() {
        showNavigationItem(leftImage: UIImage(systemName: "chevron.left"), rightImage: starStatus.icon, title: "Movie Details")
    }
    
    private func setupUI() {
        movieNameLabel.text = viewModel.getMovieData()?.title
        movieDescriptionLabel.text = viewModel.getMovieData()?.overview
        voteCountLabel.text = "Vote Count: " + (viewModel.getMovieData()?.voteCount?.string ?? "")
        if let posterPath = viewModel.getMovieData()?.posterPath {
            posterImageView.loadImage(fromURL: posterPath.toPosterUrl)
        }
    }
    
    func updateStarStatus() {
        showNavigationItem(leftImage: UIImage(systemName: "chevron.left"), rightImage: starStatus.icon, title: "Movie Details")
    }
    
    override func clickRightIcon() {
        showProgress()
        guard let movieId = viewModel.getMovieData()?.id else { return }
        if starStatus == .unliked {
            DataManager.shared.favoriteMovies?.append(movieId)
        } else {
            guard let id = DataManager.shared.favoriteMovies?.firstIndex(of: movieId) else { return }
            DataManager.shared.favoriteMovies?.remove(at: id)
        }
        starStatus = starStatus.changeStatus(starStatus)
        delegate?.updatedMovieStar(at: movieId)
    }
}
