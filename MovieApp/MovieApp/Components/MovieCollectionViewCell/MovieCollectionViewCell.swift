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

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
    }
    
    func configure(data: MovieCollectionViewUIModel?, isStarHidden: Bool = true) {
        guard let data else { return }
        starImageView.isHidden = isStarHidden
        movieNameLabel.text = data.title
        if let poster = data.poster {
            posterImageView.loadImage(fromURL: poster)
        }
    }
}
