//
//  AlbumsLocalStorage.swift
//  Albums
//
//  Created by Artem on 8/3/22.
//

import RealmSwift

typealias RealmResults = Results

final class AlbumsLocalStorage {
    
    @discardableResult
    func saveAlbums(albums: [Album]) -> Error? {
        do {
            let localRealm = try Realm()
            try localRealm.write {
                localRealm.add(albums, update: .all)
            }
            return nil
        } catch let error {
            return error
        }
    }
    
    func storedAlbums(successCompletion: (RealmResults<Album>) -> Void,
                      errorCompletion: (Error) -> Void) {
        do {
            let localRealm = try Realm()
            let albums = localRealm.objects(Album.self)
            successCompletion(albums)
        } catch let error {
            errorCompletion(error)
        }
    }
}
