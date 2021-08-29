//
//  Playlist.swift
//  spotify clone
//
//  Created by Игорь Морозов on 18.08.2021.
//

import Foundation


struct FeaturedPlaylistsResponse: Codable {
    let message: String
    let playlists: PlaylistsResponse
    
}

struct PlaylistsResponse: Codable {
    let next: String?
    let previous: String?
    let limit: Int
    let total: Int
    let items: [Playlist]
}

struct Playlist: Codable {
    let description: String?
    let id: String
    let external_ulrs: [String: String]?
    let images: [APIImage]
    let name: String
    let owner: User
}

struct User: Codable{
    let display_name: String
    let external_urls: [String: String]?
    let id: String
}
