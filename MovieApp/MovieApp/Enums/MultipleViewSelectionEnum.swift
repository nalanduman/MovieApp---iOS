//
//  MultipleViewSelectionEnum.swift
//  MovieApp
//
//  Created by Nalan Duman on 13.12.2024.
//

import Foundation
import UIKit

enum MultipleViewSelectionEnum {
    case single, multiple
    
    var icon: UIImage? {
        switch self {
        case .single:
            return UIImage(named: "table")
        case .multiple:
            return UIImage(named: "window")
        }
    }
}
