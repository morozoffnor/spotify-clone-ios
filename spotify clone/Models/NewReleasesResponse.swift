//
//  NewReleasesResponse.swift
//  spotify clone
//
//  Created by Игорь Морозов on 25.08.2021.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}
