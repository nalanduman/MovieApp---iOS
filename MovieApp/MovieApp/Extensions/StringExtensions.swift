//
//  StringExtensions.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation

extension String {
    var toPosterUrl: String {
        "https://image.tmdb.org/t/p/w500/\(self)"
    }
}
