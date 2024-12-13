//
//  StarStatusEnum.swift
//  MovieApp
//
//  Created by Nalan Duman on 13.12.2024.
//

import Foundation
import UIKit

enum StarStatusEnum: String {
    case liked = "liked"
    case unliked = "unliked"
    
    var icon: UIImage? {
        switch self {
        case .liked:
            return UIImage(systemName: "star.fill")
        case .unliked:
            return UIImage(systemName: "star")
        }
    }
    
    mutating func changeStatus(_ status: StarStatusEnum) -> StarStatusEnum {
        status == .liked ? .unliked : .liked
    }
}
