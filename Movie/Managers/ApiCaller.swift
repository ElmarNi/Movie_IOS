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
                if let data = data, error == nil {
                    do{
                        let genres = try JSONDecoder().decode(Genres.self, from: data)
                        completion(.success(genres))
                    }
                    catch {
                        completion(.failure(NSError()))
                    }
                }
                else {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getUpcomingMovies(page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<UpcomingMovie, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/movie/upcoming?page=\(page)"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                if let data = data, error == nil {
                    do{
                        let movies = try JSONDecoder().decode(UpcomingMovie.self, from: data)
                        completion(.success(movies))
                    }
                    catch {
                        completion(.failure(NSError()))
                    }
                }
                else {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getTopRatedMovies(page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovie, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/movie/top_rated?page=\(page)"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                if let data = data, error == nil {
                    do{
                        let movies = try JSONDecoder().decode(CommonMovie.self, from: data)
                        completion(.success(movies))
                    }
                    catch {
                        completion(.failure(NSError()))
                    }
                }
                else {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getPopularMovies(page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovie, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/movie/popular?page=\(page)"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                if let data = data, error == nil {
                    do{
                        let movies = try JSONDecoder().decode(CommonMovie.self, from: data)
                        completion(.success(movies))
                    }
                    catch {
                        completion(.failure(NSError()))
                    }
                }
                else {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getMoviesByGenreId(with genreId: Int, page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovie, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&page=\(page)&sort_by=popularity.desc&with_genres=\(genreId)"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                if let data = data, error == nil {
                    do{
                        let movies = try JSONDecoder().decode(CommonMovie.self, from: data)
                        completion(.success(movies))
                    }
                    catch {
                        completion(.failure(NSError()))
                    }
                }
                else {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getMoviesByName(with name: String, page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovie, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/search/movie?query=\(name)&page=\(page)"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                if let data = data, error == nil {
                    do{
                        let movies = try JSONDecoder().decode(CommonMovie.self, from: data)
                        completion(.success(movies))
                    }
                    catch {
                        completion(.failure(NSError()))
                    }
                }
                else {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func getMoviesByUserId(with userId: Int, page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovie, Error>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/account/\(userId)/favorite/movies?page=\(page)&sort_by=created_at.asc"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                if let data = data, error == nil {
                    do{
                        let movies = try JSONDecoder().decode(CommonMovie.self, from: data)
                        completion(.success(movies))
                    }
                    catch {
                        completion(.failure(NSError()))
                    }
                }
                else {
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
                if let data = data, error == nil {
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
                }
                else {
                    completion(false)
                }
            }.resume()
        }
    }
    
    public func getKey(sessionDelegate: URLSessionDelegate, completion: @escaping (Result<GetKey, Error>) -> Void)
    {
        createRequest(with: URL(string: "https://api.themoviedb.org/3//authentication/token/new"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                if let data = data, error == nil {
                    do{
                        let key = try JSONDecoder().decode(GetKey.self, from: data)
                        completion(.success(key))
                    }
                    catch {
                        completion(.failure(NSError()))
                    }
                }
                else {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func authenticate(username: String, password: String, apiKey: String, sessionDelegate: URLSessionDelegate,
                             completion: @escaping (Result<GetKey, Error>) -> Void)
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
                if let data = data, error == nil {
                    do {
                        let key = try JSONDecoder().decode(GetKey.self, from: data)
                        completion(.success(key))
                    }
                    catch {
                        completion(.failure(NSError()))
                    }
                }
                else {
                    completion(.failure(NSError()))
                }
            }.resume()
        }
    }
    
    public func fetchUserData(apiKey: String, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<User, Error>) -> Void)
    {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/account?api_key=\(apiKey)"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                if let data = data, error == nil {
                    do{
                        let user = try JSONDecoder().decode(User.self, from: data)
                        UserDefaults.standard.setValue(user.id, forKey: "UserId")
                        UserDefaults.standard.setValue(user.username, forKey: "UserName")
                        completion(.success(user))
                    }
                    catch {
                        completion(.failure(NSError()))
                    }
                }
                else {
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
