//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation
import UIKit

final class MovieListViewController: BaseViewController {
    @IBOutlet weak var movieSearchBar: BaseSearchBar!
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    
    lazy var viewModel: MovieListViewModel = {
        return MovieListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        configureSearchBar()
        configureCollectionView()
        setupUI()
        initVM()
    }
    
    private func initVM() {
        viewModel.moviesCallback = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.reloadCollectionView()
                self.hideProgress()
            }
        }
        viewModel.getPopularMovies()
    }
    
    private func configureSearchBar() {
        movieSearchBar.baseSearchBarDelegate = self
    }

    private func configureCollectionView() {
        movieListCollectionView.delegate = self
        movieListCollectionView.dataSource = self
        registerCollectionViewNibs()
    }
    
    private func registerCollectionViewNibs() {
        movieListCollectionView.registerNib(MovieCollectionViewCell.self)
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.movieListCollectionView.reloadData()
        }
    }
    
    private func setupUI() {
        movieSearchBar.placeholder = "Search Movies"
        showNavigationItem(title: "Movie List")
    }
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getMovies().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseId, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        let movie = viewModel.getMovie(at: indexPath.row)
        let movieUIModel = MovieCollectionViewUIModel(title: movie?.title, poster: movie?.backdropPath?.toPosterUrl)
        cell.configure(data: movieUIModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.setSelectedMovieID(at: indexPath.row)
        presentMovieDetail()
    }
    
    private func presentMovieDetail() {
        let vc = MovieDetailBuilder.make(movieId: viewModel.getSelectedMovieID())
        let nav = UINavigationController(rootViewController: vc)
        vc.delegate = self
        nav.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(nav, animated: true, completion: nil)
        }
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (movieListCollectionView.frame.width - 10) / 2
        return CGSize(width: cellWidth, height: 200)
    }
}

extension MovieListViewController: MovieDetailViewControllerProtocol {
    func updatedMovieStar(at id: Int) {
        guard let updatedMovieIndex = viewModel.getMovies().firstIndex(where: { $0.id == id }) else { return }
        let indexPath = IndexPath(row: updatedMovieIndex, section: 0)
        movieListCollectionView.guardedReloadItems(at: indexPath)
    }
}

extension MovieListViewController: BaseSearchBarDelegate {
    func searchBarFilterWith(text: String) {
        guard text.count >= 3 else { return viewModel.resetSearchList() }
        showProgress()
        viewModel.searchMovies(with: text)
    }
    
    func searchBarResetSearch() {
        viewModel.resetSearchList()
    }
}
