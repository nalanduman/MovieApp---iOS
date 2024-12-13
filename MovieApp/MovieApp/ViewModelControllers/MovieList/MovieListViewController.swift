//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation
import UIKit

final class MovieListViewController: BaseViewController {
    @IBOutlet private weak var movieSearchBar: BaseSearchBar!
    @IBOutlet private weak var movieListCollectionView: UICollectionView!
    @IBOutlet private weak var multipleSelectionImageView: UIImageView!
    
    lazy var viewModel: MovieListViewModel = {
        return MovieListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        setMultipleSelectionViewGesture()
        configureSearchBar()
        configureCollectionView()
        setupUI()
        initVM()
    }
    
    private func initVM() {
        viewModel.moviesCallback = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.multipleSelectionImageView.image = self.viewModel.getViewSelection().icon
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
        movieListCollectionView.registerSupplementaryNibCustom(CustomFooterView.self, kind: UICollectionView.elementKindSectionFooter)
        movieListCollectionView.registerNib(MovieCollectionViewCell.self)
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.movieListCollectionView.collectionViewLayout.invalidateLayout()
            self.movieListCollectionView.reloadData()
        }
    }
    
    private func setMultipleSelectionViewGesture() {
        multipleSelectionImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMultipleSelectionImageViewTap))
        multipleSelectionImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupUI() {
        movieSearchBar.placeholder = "Search Movies"
        showNavigationItem(title: "Movie List")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func handleMultipleSelectionImageViewTap() {
        viewModel.changeMultipleSelectionState()
    }
    
    @objc func handlePagination() {
        viewModel.getPopularMoviesPaginating()
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
        let isStarHidden = DataManager.shared.favoriteMovies?.filter({ $0 == movie?.id }).count ?? 0 > 0
        cell.configure(data: movieUIModel, isStarHidden: !isStarHidden)
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
        if viewModel.isMultipleSelection() {
            let width = (movieListCollectionView.frame.width) / 2.0
            let cellsHorizontalSpacing: CGFloat = 10
            let cellHeight: CGFloat = 441
            return .init(width: width - cellsHorizontalSpacing, height: cellHeight)
        } else {
            let cellHeight: CGFloat = 707
            return .init(width: movieListCollectionView.frame.width, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableView(CustomFooterView.self, kind: UICollectionView.elementKindSectionFooter, for: indexPath)
            footerView.onTap = {
                self.viewModel.paginationMovies()
            }
            return footerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
        guard text.count >= 3 else { return }
        showProgress()
        viewModel.resetPage()
        viewModel.searchMovies(with: text)
    }
    
    func searchBarResetSearch() {
        viewModel.resetPage()
        viewModel.getPopularMovies()
    }
}
