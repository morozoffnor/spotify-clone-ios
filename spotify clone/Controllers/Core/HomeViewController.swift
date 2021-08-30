//
//  ViewController.swift
//  spotify clone
//
//  Created by Игорь Морозов on 18.08.2021.
//

import UIKit

enum BrowseSectionType {
    case newReleases
    case featureedPlaylists
    case RecommendedTracks
}

class HomeViewController: UIViewController {
    
    // create a collection view with layout
    private var collectionView:  UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout:
            UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                // can't use self here so call HomeViewController directly
                return HomeViewController.createSectionLayout(section: sectionIndex)
     })
    // spinner view
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        // view background color
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        
        // order matters!
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    
    // MARK: Fetch Data
    
    // Get featured playlists, recommended tracks and new releases playlist
    private func fetchData() {
        APICaller.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                
                APICaller.shared.getRecommendations(genres: seeds) { _ in
                    
                }
            case .failure( _): break
            }
        }
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }

    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: Extension

// extension to match requirement for protocol UIViewController
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: Layout
    
    // create sections for layout
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
        // MARK: New Releases
        case 0:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 2, trailing: 2)
            
            // vertical group inside a horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem:
                    item,
                count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .absolute(390)
                ),
                subitem:
                    verticalGroup,
                count: 1)
            
            // section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            // snap to the next element when scrolling through
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        // MARK: Featured Playlists
        case 1:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 2, trailing: 2)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem:
                    item,
                count: 2)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitem:
                    verticalGroup,
                count: 1)
            
            // section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            // snap to the next element when scrolling through
            section.orthogonalScrollingBehavior = .continuous
            return section
        // MARK: Recommended Tracks
        case 2:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 2, trailing: 2)
            
            // vertical group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(80)
                ),
                subitem:
                    item,
                count: 1)
            
            // section
            let section = NSCollectionLayoutSection(group: verticalGroup)
            return section
        // MARK: Default section
        default:
            // item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 2, trailing: 2)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem:
                    item,
                count: 1)
            // section
            let section = NSCollectionLayoutSection(group: verticalGroup)
            // snap to the next element when scrolling through
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // cells layout debugging
        if indexPath.section == 0 {
            cell.backgroundColor = .systemGreen
        }
        if indexPath.section == 1 {
            cell.backgroundColor = .systemBlue
        }
        if indexPath.section == 2 {
            cell.backgroundColor = .systemPink
        }
        return cell
    }
    
    
}
