//
//  UICollectionViewExtensions.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import UIKit

extension UICollectionViewCell {
    class var reuseId: String {
        return String(describing: self)
    }
}
