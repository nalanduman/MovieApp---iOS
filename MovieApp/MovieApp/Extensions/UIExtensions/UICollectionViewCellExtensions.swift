//
//  UICollectionViewCellExtensions.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import UIKit

extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(_: T.Type) {
        self.register(UINib(nibName: String(describing: T.self), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(_: T.Type, kind: String, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else { fatalError("Could not deque view with type \(T.self)") }
        return view
    }
    
    func registerSupplementaryNib<T: UICollectionReusableView>(_: T.Type, kind: String) {
        self.register(UINib(nibName: String(describing: T.self), bundle: Bundle.main), forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: T.self))
    }
    func registerSupplementaryNibCustom<T: UICollectionReusableView>(_ customClass: T.Type, kind: String) {
        self.register(customClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: T.self))
    }

    func guardedScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        if numberOfSections > indexPath.section, numberOfItems(inSection: 0) > indexPath.row {
            self.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
            self.setNeedsDisplay()
        }
    }
    
    func guardedReloadItems(at indexPath: IndexPath) {
        if numberOfSections > indexPath.section, numberOfItems(inSection: 0) > indexPath.row {
            self.reloadItems(at: [indexPath] )
            self.setNeedsDisplay()
        }
    }
}
