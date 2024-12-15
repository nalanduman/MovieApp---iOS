//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation
import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var starImageView: UIImageView!

    @IBOutlet private weak var viewWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var viewHeightLayoutConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(data: MovieCollectionViewUIModel?, isStarHidden: Bool = true) {
        guard let data else { return }
        starImageView.isHidden = isStarHidden
        movieNameLabel.text = data.title
        if let poster = data.poster {
            posterImageView.loadImage(fromURL: poster)
        }
    }
    
    func configureSize(with size: CGSize) {
        viewWidthLayoutConstraint.constant = size.width
        viewHeightLayoutConstraint.constant = size.height
    }
}
