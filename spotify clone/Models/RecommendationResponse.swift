//
//  RecommendationResponse.swift
//  spotify clone
//
//  Created by Игорь Морозов on 29.08.2021.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
