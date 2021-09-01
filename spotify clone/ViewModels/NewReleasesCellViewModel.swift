//
//  NewReleasesCellViewModel.swift
//  spotify clone
//
//  Created by Игорь Морозов on 30.08.2021.
//

import Foundation

struct NewReleasesCellViewModel {
    internal init(name: String, artworkURL: URL?, numberOfTracks: Int, artistName: String) {
        self.name = name
        self.artworkURL = artworkURL
        self.numberOfTracks = numberOfTracks
        self.artistName = artistName
    }
    
    let name: String
    let artworkURL: URL?
    let numberOfTracks: Int
    let artistName: String
}
