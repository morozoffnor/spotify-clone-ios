//
//  APICaller.swift
//  spotify clone
//
//  Created by Игорь Морозов on 18.08.2021.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseApiUrl = "https://api.spotify.com/v1"
    }
    
    enum apiError: Error {
        case failedToGetData
    }
    
    // MARK: User Profile
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseApiUrl + "/me"), type: .GET) { baseRequest in
            // get data
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _ , error in
                guard let data = data, error == nil else {
                    // if failed
                    completion(.failure(apiError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    // MARK: Get New Releases
    
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.baseApiUrl + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(apiError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: Get Featured Playlists
    
    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistsResponse, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseApiUrl + "/browse/featured-playlists?limit=2"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(apiError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    // let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    // print(result)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    // MARK: TODO: Get Recommendations
    
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void )) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseApiUrl + "/recommendations?limit=50&seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(apiError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    // let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(result)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    // MARK: Get Recommended Genres

    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>) -> Void )) {
        createRequest(with: URL(string: Constants.baseApiUrl + "/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(apiError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    // let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    // print(result)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    
    
    // MARK: Generic Request
    
    // enum for http methods
    enum Method: String {
        case GET
        case POST
    }
    
    // create a generic request which will be used for everything else to build on top of
    private func createRequest(with url: URL?, type: Method, completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            
            completion(request)
        }
        
    }
}
