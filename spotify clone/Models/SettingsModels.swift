//
//  SettingsModels.swift
//  spotify clone
//
//  Created by Игорь Морозов on 24.08.2021.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
    
}

struct Option {
    let title: String
    let handler: () -> Void
}
