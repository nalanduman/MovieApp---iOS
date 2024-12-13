//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation
import UIKit

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

    weak var delegate: MovieDetailViewControllerProtocol?
    
    lazy var viewModel: MovieDetailViewModel = {
        return MovieDetailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func initVM() {
        viewModel.reloadView = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.viewModel.changeStarStatus()
                self.hideProgress()
            }
        }
        viewModel.updatedStarStatus = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.updateStarStatus()
            }
        }
    }
    
    private func setup() {
        setNavigationBar()
        setupUI()
        initVM()
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
        guard let movieId = viewModel.getMovieData()?.id else { return }
        setNavigationBar()
        viewModel.setFavoritedMovie(with: movieId)
        delegate?.updatedMovieStar(at: movieId)
    }
    
    override func clickRightIcon() {
        showProgress()
        guard let base64Image = posterImageView.image?.resizedImage()?.toBase64() else { return }
        viewModel.setTextToImageUpload(base64str: base64Image)
    }
    
    func setNavigationBar() {
        showNavigationItem(leftImage: UIImage(systemName: "chevron.left"), rightImage: viewModel.getStarStatus().icon, title: "Movie Details")
    }
}
