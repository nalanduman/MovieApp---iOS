//
//  UIViewExtensions.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import UIKit

extension UIView {
    func loadViewFromXib(nibName: String) {
        guard let xibView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else { return }
        xibView.frame = self.bounds
        self.addSubview(xibView)
    }
}
