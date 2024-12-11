//
//  UIImageViewExtensions.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import UIKit

extension UIImageView {
    func loadImage(fromURL urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
