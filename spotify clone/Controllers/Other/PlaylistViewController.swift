//
//  PlaylistViewController.swift
//  spotify clone
//
//  Created by Игорь Морозов on 18.08.2021.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    private let playlist: Playlist
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        
        APICaller.shared.getPlaylistDetails(for: playlist) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    break
                case .failure(let error):
                    break
                }
            }
            
        }
    }

}
