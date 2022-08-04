//
//  AlbumsAPI.swift
//  Albums
//
//  Created by Artem on 8/3/22.
//

import Foundation

private let baseURL = URL(string: "https://rss.applemarketingtools.com")

final class AlbumsAPI {
    
    init() {
        URLSession.shared.configuration.timeoutIntervalForRequest = 30
    }
    
    func fetchAlbums(count: Int,
                     successCompletion: @escaping (Feed) -> Void,
                     errorCompletion: @escaping (Error) -> Void) {
        
        guard let url = WebAPIRouter.mostPlayed.urlWithRecords(count: count) else {
            errorCompletion("API URL is broken")
            return
        }

        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
             
                if let data = data {
                    do {
                        let feed = try JSONDecoder().decode(Feed.self, from: data)
                        successCompletion(feed)
                    } catch let error {
                        errorCompletion(error)
                    }
                } else if let error = error {
                    errorCompletion(error)
                }
                
            }
        }.resume()
    }
}

fileprivate enum WebAPIRouter {
    
    case mostPlayed
    
    func urlWithRecords(count: Int = 10) -> URL? {
        return baseURL?.appendingPathComponent("api/v2/us/music/most-played/\(count)/albums.json")
    }
}
