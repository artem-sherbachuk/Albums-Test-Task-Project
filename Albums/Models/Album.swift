//
//  Album.swift
//  Albums
//
//  Created by Artem on 8/3/22.
//

import Foundation
import RealmSwift

final class Album: Object, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case artistName, id, name, releaseDate, kind, artistId, artistUrl, contentAdvisoryRating, artworkUrl100, url, genres
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var artistName: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var name:  String = ""
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var kind: String = ""
    @objc dynamic var artistId: String = ""
    @objc dynamic var artistUrl: String = ""
    @objc dynamic var contentAdvisoryRating: String = ""
    @objc dynamic var artworkUrl100: String = ""
    @objc dynamic var url: String = ""
    var genres = List<AlbumGenere>()
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        artistName = try values.decodeIfPresent(String.self, forKey: .artistName) ?? ""
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        kind = try values.decodeIfPresent(String.self, forKey: .kind) ?? ""
        artistId = try values.decodeIfPresent(String.self, forKey: .artistId) ?? ""
        artistUrl = try values.decodeIfPresent(String.self, forKey: .artistUrl) ?? ""
        contentAdvisoryRating = try values.decodeIfPresent(String.self, forKey: .contentAdvisoryRating) ?? ""
        artworkUrl100 = try values.decodeIfPresent(String.self, forKey: .artworkUrl100) ?? ""
        url = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
        let genres = try values.decodeIfPresent([AlbumGenere].self, forKey: .genres) ?? []
        self.genres.append(objectsIn: genres)
    }
}

final class AlbumGenere: Object, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case genreId, name, url
    }
    
    override class func primaryKey() -> String? {
        return "url"
    }
    
    @objc dynamic var genreId: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        genreId = try values.decodeIfPresent(String.self, forKey: .genreId) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        url = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
    }
}

