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
                if let error {
                    print("Error: \(error.localizedDescription)")
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
    
    func postRequest(to url: URL, requestBody: [String: Any], completion: @escaping (Data?) -> Void) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            let serializationError = NSError(domain: "SerializationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize JSON"])
            print("Error: \(serializationError.localizedDescription)")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                let networkError = NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("Error: \(networkError.localizedDescription)")
                completion(nil)
                return
            }
            
            completion(data)
        }
        
        task.resume()
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
    func getPopularMovies(page: Int, completion: @escaping (MovieListResponseModel?) -> Void) {
        performRequest(urlString: baseURL + "movie/popular?api_key=\(apiKey)&page=\(page)") { data in
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
    
    func searchMovie(_ searchText: String, page: Int, completion: @escaping (MovieListResponseModel?) -> Void) {
        performRequest(urlString: baseURL + "search/movie?query=\(searchText)&api_key=\(apiKey)&page=\(page)") { data in
            guard let data = data, let parseData = self.parseJSON(data: data, type: MovieListResponseModel.self) else { return completion(nil) }
            completion(parseData)
        }
    }
    
    func sendTextToImageRequest(prompt: String, base64str: String, inputImage: Bool, completion: @escaping (TextToImageResponseModel?) -> Void) {
        guard let url = URL(string: "https://www.nftcalculatorsapp.net/text_to_image_case_study") else {
            print("Invalid URL")
            return
        }

        let requestBody: [String: Any] = [
            "prompt": prompt,
            "base64str": base64str,
            "inputImage": inputImage
        ]
        postRequest(to: url, requestBody: requestBody) { data in
            guard let data = data, let parseData = self.parseJSON(data: data, type: TextToImageResponseModel.self) else { return completion(nil) }
            completion(parseData)
        }
    }
}
