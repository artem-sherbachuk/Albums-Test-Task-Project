//
//  Feed.swift
//  Albums
//
//  Created by Artem on 8/3/22.
//

import Foundation

struct Feed: Decodable {
    let feed: FeedPage
}

struct FeedPage: Decodable {
    let title: String
    let id: String
    let author: Author
    let links: [Link]
    let copyright: String
    let country: String
    let icon: String
    let updated: String
    let results : [Album]
    
    enum CodingKeys: String, CodingKey {
        case title, id, author, links, copyright, country, icon, updated, results
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        author = try values.decodeIfPresent(Author.self, forKey: .author) ?? Author(name: "", url: "")
        links = try values.decodeIfPresent([Link].self, forKey: .links) ?? []
        copyright = try values.decodeIfPresent(String.self, forKey: .copyright) ?? ""
        country = try values.decodeIfPresent(String.self, forKey: .country) ?? ""
        icon = try values.decodeIfPresent(String.self, forKey: .icon) ?? ""
        updated = try values.decodeIfPresent(String.self, forKey: .updated) ?? ""
        results = try values.decodeIfPresent([Album].self, forKey: .results) ?? []
    }
}

struct Author: Decodable {
    
    let name: String
    let url: String
    
    internal init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case name, url
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        url = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
    }
}

struct Link: Decodable {
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case link = "self"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        link = try values.decodeIfPresent(String.self, forKey: .link) ?? ""
    }
}
