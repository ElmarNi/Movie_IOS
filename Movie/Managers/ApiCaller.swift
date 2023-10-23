//
//  ApiCaller.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 03.10.23.
//

import Foundation
import UIKit

final class ApiCaller {
    
    static let shared = ApiCaller()
    
    enum HTTPMethod: String {
        case GET
        case POST
        case DELETE
        case PUT
    }
    
    public func getGenres(sessionDelegate: URLSessionDelegate, completion: @escaping (Result<Genres, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/genre/movie/list"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(NSError()))
                    return
                }
                do{
                    let genres = try JSONDecoder().decode(Genres.self, from: data)
                    completion(.success(genres))
                }
                catch {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getUpcomingMovies(page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovieResponse, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/movie/upcoming?page=\(page)"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(NSError()))
                    return
                }
                do{
                    let movies = try JSONDecoder().decode(CommonMovieResponse.self, from: data)
                    completion(.success(movies))
                }
                catch {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getTopRatedMovies(page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovieResponse, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/movie/top_rated?page=\(page)"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(NSError()))
                    return
                }
                do{
                    let movies = try JSONDecoder().decode(CommonMovieResponse.self, from: data)
                    completion(.success(movies))
                }
                catch {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getPopularMovies(page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovieResponse, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/movie/popular?page=\(page)"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(NSError()))
                    return
                }
                do{
                    let movies = try JSONDecoder().decode(CommonMovieResponse.self, from: data)
                    completion(.success(movies))
                }
                catch {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getMoviesByGenreId(with genreId: Int, page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovieResponse, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&page=\(page)&sort_by=popularity.desc&with_genres=\(genreId)"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(NSError()))
                    return
                }
                do{
                    let movies = try JSONDecoder().decode(CommonMovieResponse.self, from: data)
                    completion(.success(movies))
                }
                catch {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getMoviesByName(with name: String, page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovieResponse, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/search/movie?query=\(name)&page=\(page)"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(NSError()))
                    return
                }
                do{
                    let movies = try JSONDecoder().decode(CommonMovieResponse.self, from: data)
                    completion(.success(movies))
                }
                catch {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getMoviesByUserId(with userId: Int, page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovieResponse, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/account/\(userId)/favorite/movies?page=\(page)&sort_by=created_at.asc"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(NSError()))
                    return
                }
                do{
                    let movies = try JSONDecoder().decode(CommonMovieResponse.self, from: data)
                    completion(.success(movies))
                }
                catch {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func addOrRemoveFromFavourite(with movieId: Int, userId: Int, add: Bool, sessionDelegate: URLSessionDelegate, completion: @escaping (Bool) -> Void)
    {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/account/\(userId)/favorite"), type: .POST) { baseRequest in
            
            var request = baseRequest
            let parameters: [String: Any] = [
                "media_type": "movie",
                "media_id": movieId,
                "favorite": add
            ]
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let success = json["success"] as? Int,
                       success == 1
                    {
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                }
                catch {
                    completion(false)
                }
            }.resume()
        }
    }
    
    public func getMovieTrailer(with movieId: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<String, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos?language=en-US"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(NSError()))
                    return
                }
                do{
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let results = json["results"] as? [[String: Any]]
                    else {
                        completion(.failure(NSError()))
                        return
                    }
                    
                    for result in results {
                        if let site = result["site"] as? String,
                           let type = result["type"] as? String,
                           site == "YouTube", type == "Trailer",
                           let key = result["key"] as? String
                        {
                            completion(.success(key))
                            break
                        }
                    }
                }
                catch {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getMovieReviewsById(with movieId: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<ReviewResponse, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/reviews"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(NSError()))
                    return
                }
                do{
                    let reviews = try JSONDecoder().decode(ReviewResponse.self, from: data)
                    completion(.success(reviews))
                }
                catch {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getKey(sessionDelegate: URLSessionDelegate, completion: @escaping (Result<String, Error>) -> Void)
    {
        createRequest(with: URL(string: "https://api.themoviedb.org/3//authentication/token/new"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(NSError()))
                    return
                }
                do{
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let request_token = json["request_token"] as? String
                    else {
                        completion(.failure(NSError()))
                        return
                    }
                    completion(.success(request_token))
                }
                catch {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func authenticate(username: String, password: String, apiKey: String, sessionDelegate: URLSessionDelegate,
                             completion: @escaping (Result<String, Error>) -> Void)
    {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login"), type: .POST) { baseRequest in
            
            var request = baseRequest
            let parameters: [String: String] = [
                "username": username,
                "password": password,
                "request_token": apiKey
            ]
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(NSError()))
                    return
                }
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let request_token = json["request_token"] as? String
                    else {
                        completion(.failure(NSError()))
                        return
                    }
                    completion(.success(request_token))
                }
                catch {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func fetchUserData(apiKey: String, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<Bool, Error>) -> Void)
    {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/account?api_key=\(apiKey)"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(NSError()))
                    return
                }
                do{
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let userId = json["id"] as? Int,
                          let userName = json["username"] as? String
                    else {
                        completion(.failure(NSError()))
                        return
                    }
                    
                    UserDefaults.standard.setValue(userId, forKey: "UserId")
                    UserDefaults.standard.setValue(userName, forKey: "UserName")
                    completion(.success(true))
                }
                catch {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func logOut() {
        UserDefaults.standard.setValue(nil, forKey: "UserId")
        UserDefaults.standard.setValue(nil, forKey: "UserName")
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        guard let url = url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YWNhMDEwNmFlZThlY2U0ZDMwOThlNTcwNGQxZTJkMCIsInN1YiI6IjY1MTZkMGEzOTY3Y2M3MDBhY2I4NzJhZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.oQF0cgq58KX3nIam3qWauiK4iaG3B6IwhyNQkv7fsAQ", forHTTPHeaderField: "Authorization")
        completion(request)
    }
}
