//
//  DBRepository.swift
//  Albums
//
//  Created by Artem on 8/3/22.
//

import Foundation

final class DBRepository {
    
    let localDB = AlbumsLocalStorage()
    
    let remoteDB = AlbumsAPI()
    
    private var albumsCount: Int = 10
    
    private var isFetching: Bool = false
    
    func fetchAlbums(count: Int, successCompletion: @escaping (RealmResults<Album>) -> Void,
                     errorCompletion: @escaping (Error) -> Void) {
        localDB.storedAlbums(successCompletion: successCompletion, errorCompletion: errorCompletion)
        
        remoteDB.fetchAlbums(count: count, successCompletion: { [weak self] result in
            let albums = result.feed.results
            self?.localDB.saveAlbums(albums: albums)
            self?.localDB.storedAlbums(successCompletion: successCompletion, errorCompletion: errorCompletion)
        }, errorCompletion: errorCompletion)
    }
    
    func fetchMoreAlbums(successCompletion: @escaping (RealmResults<Album>) -> Void,
                         errorCompletion: @escaping (Error) -> Void) {
        if isFetching {
            return
        }
        
        isFetching = true
        albumsCount += 10
        
        remoteDB.fetchAlbums(count: albumsCount, successCompletion: { [weak self] result in
            let albums = result.feed.results
            self?.localDB.saveAlbums(albums: albums)
            self?.localDB.storedAlbums(successCompletion: successCompletion, errorCompletion: errorCompletion)
            self?.isFetching = false
        }) { [weak self] error in
            self?.isFetching = false
            errorCompletion(error)
        }
    }
}
