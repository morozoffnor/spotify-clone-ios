//
//  PlaylistDetailsResponse.swift
//  spotify clone
//
//  Created by Игорь Морозов on 05.09.2021.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let primary_color: String
    let `public`: Bool
    let tracks: PlaylistTracksResponse
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}
