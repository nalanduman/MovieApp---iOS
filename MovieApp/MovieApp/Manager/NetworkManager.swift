//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import Foundation

class NetworkManager {
    let baseURL = "https://api.themoviedb.org/3/"
    let apiKey = "12dae759553a27c1adae425693d079cc"

    static let shared = NetworkManager()
    
    private func performRequest(urlString: String, completion: @escaping (Data?) -> Void) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Hata: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                completion(data)
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
    
    private func parseJSON<T: Decodable>(data: Data, type: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            print("JSON dönüştürme hatası: \(error.localizedDescription)")
            return nil
        }
    }
}

extension NetworkManager {
    func getPopularMovies(completion: @escaping (MovieListResponseModel?) -> Void) {
        performRequest(urlString: baseURL + "movie/popular?api_key=\(apiKey)") { data in
            guard let data = data, let parseData = self.parseJSON(data: data, type: MovieListResponseModel.self) else { return completion(nil) }
            completion(parseData)
        }
    }
    
    func getMovie(_ id: Int, completion: @escaping (MovieDetailResponseModel?) -> Void) {
        performRequest(urlString: baseURL + "movie/\(id)?api_key=\(apiKey)") { data in
            guard let data = data, let parseData = self.parseJSON(data: data, type: MovieDetailResponseModel.self) else { return completion(nil) }
            completion(parseData)
        }
    }
    
    func searchMovie(_ searchText: String, completion: @escaping (MovieListResponseModel?) -> Void) {
        performRequest(urlString: baseURL + "search/movie?query=\(searchText)?api_key=\(apiKey)") { data in
            guard let data = data, let parseData = self.parseJSON(data: data, type: MovieListResponseModel.self) else { return completion(nil) }
            completion(parseData)
        }
    }
}
