//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation
import UIKit

final class MovieListViewController: BaseViewController {
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    
    lazy var viewModel: MovieListViewModel = {
        return MovieListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        configureCollectionView()
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
        
    }
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseId, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width
        return CGSize(width: cellWidth, height: 200)
    }
}
