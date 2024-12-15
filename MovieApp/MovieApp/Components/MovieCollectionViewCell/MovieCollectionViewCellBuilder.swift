//
//  MovieCollectionViewCellBuilder.swift
//  MovieApp
//
//  Created by Nalan Duman on 15.12.2024.
//

import Foundation
import UIKit

final class MovieCollectionViewCellBuilder {
    func build(with movie: MovieCollectionViewUIModel?, at indexPath: IndexPath, isStarHidden: Bool = true, collectionView: UICollectionView, isMultipleSelection: Bool = true) -> MovieCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseId, for: indexPath) as! MovieCollectionViewCell
        let width = collectionView.frame.width
        let multipleWidth = (width / 2.0) - 10
        let multipleSize = CGSize(width: multipleWidth, height: (260 * multipleWidth) / 175)
        let singleSize = CGSize(width: width, height: (205 * width) / 360)

        cell.configureSize(with: isMultipleSelection ? multipleSize : singleSize)
        cell.configure(data: movie, isStarHidden: isStarHidden)

        return cell
    }
}
