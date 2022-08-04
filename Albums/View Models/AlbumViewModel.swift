//
//  AlbumViewModel.swift
//  Albums
//
//  Created by Artem on 8/3/22.
//

import UIKit

final class AlbumViewModel {
    
    internal init(imageURL: URL? = nil, artist: String, title: String, genere: [AlbumGenreViewModel] = [], albumURL: URL? = nil) {
        self.imageURL = imageURL
        self.artist = artist
        self.title = title
        self.genere = genere
        self.albumURL = albumURL
    }
    
    
    static func createFrom(_ collection: RealmResults<Album>) -> [AlbumViewModel] {
        return collection.compactMap({
            let coverImgURL = URL(string: $0.artworkUrl100)?.deletingLastPathComponent().appendingPathComponent("1024x1024bb.jpg")
            let albumURL = URL(string: $0.url)
            let genres: [AlbumGenreViewModel] = $0.genres.compactMap({ AlbumGenreViewModel(genreId: $0.genreId, name: $0.name, url: URL(string: $0.url)) })
            let album = AlbumViewModel(imageURL: coverImgURL, artist: $0.artistName, title: $0.name, genere: genres, albumURL: albumURL)
            return album
        })
    }
    
    private let imageLoader = ImageLoader()
    
    
    var imageURL: URL?
    
    var artist: String
    
    var title: String
    
    var genere: [AlbumGenreViewModel] = []
    
    var albumURL: URL?
    
    func setCoverImageFor(_ imageView: UIImageView) {
        imageView.image = imageLoader.placeholderImage
        
        guard let imageURL = imageURL else {
            return
        }

        imageLoader.loadImage(url: imageURL) { [weak imageView] image in
            imageView?.image = image
        }
    }
}

struct AlbumGenreViewModel {
    
    internal init(genreId: String, name: String, url: URL?) {
        self.genreId = genreId
        self.name = name
        self.url = url
    }
    
    let genreId: String
    let name: String
    let url: URL?
}
