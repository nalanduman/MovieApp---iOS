//
//  TextToImageResponseModel.swift
//  MovieApp
//
//  Created by Nalan Duman on 13.12.2024.
//

import Foundation

struct TextToImageResponseModel: Codable {
    let result: Bool?
    let responseMessage: String?
    let data: TextToImageData?
}

struct TextToImageData: Codable {
    let base64str: String?
    let title: String?
}
