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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(data: MovieCollectionViewUIModel?) {
        guard let data else { return }
        movieNameLabel.text = data.title
        if let poster = data.poster {
            posterImageView.loadImage(fromURL: poster)
        }
    }
}
