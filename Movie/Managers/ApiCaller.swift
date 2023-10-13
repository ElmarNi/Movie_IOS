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
    
    struct ApiError: LocalizedError {
        let description: String
        init(_ description: String) {
            self.description = description
        }
    }
    
    public func getGenres(sessionDelegate: URLSessionDelegate, completion: @escaping (Result<Genres, ApiError>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/genre/movie/list?language=en"), type: .GET) { request in
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
                        completion(.failure(ApiError("Failed get data")))
                    }
                }
                else {
                    completion(.failure(ApiError("Failed get data")))
                }
            }.resume()
        }
    }
    
    public func getUpcomingMovies(page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<UpcomingMovie, ApiError>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=\(page)"), type: .GET) { request in
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request)
            { data, _, error in
                if let data = data, error == nil {
                    do{
                        let movies = try JSONDecoder().decode(UpcomingMovie.self, from: data)
                        let json = try JSONSerialization.jsonObject(with: data)
                        completion(.success(movies))
                    }
                    catch {
                        completion(.failure(ApiError("Failed get data")))
                    }
                }
                else {
                    completion(.failure(ApiError("Failed get data")))
                }
            }.resume()
        }
    }
    
    public func getTopRatedMovies(page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovie, ApiError>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=\(page)"), type: .GET) { request in
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
                        completion(.failure(ApiError("Failed get data")))
                    }
                }
                else {
                    completion(.failure(ApiError("Failed get data")))
                }
            }.resume()
        }
    }
    
    public func getPopularMovies(page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovie, ApiError>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/movie/popular?language=en-US&page=\(page)"), type: .GET) { request in
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
                        completion(.failure(ApiError("Failed get data")))
                    }
                }
                else {
                    completion(.failure(ApiError("Failed get data")))
                }
            }.resume()
        }
    }
    
    public func getMoviesByGenreId(with genreId: Int, page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovie, ApiError>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_genres=\(genreId)"), type: .GET) { request in
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
                        completion(.failure(ApiError("Failed get data")))
                    }
                }
                else {
                    completion(.failure(ApiError("Failed get data")))
                }
            }.resume()
        }
    }
    
    public func getMoviesByName(with name: String, page: Int, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<CommonMovie, ApiError>) -> Void) {
        createRequest(with: URL(string: "https://api.themoviedb.org/3/search/movie?query=\(name)&language=en-US&page=1"), type: .GET) { request in
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
                        completion(.failure(ApiError("Failed get data")))
                    }
                }
                else {
                    completion(.failure(ApiError("Failed get data")))
                }
            }.resume()
        }
    }
    
    public func getKey(sessionDelegate: URLSessionDelegate, completion: @escaping (Result<GetKey, ApiError>) -> Void)
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
                        completion(.failure(ApiError("Failed get key")))
                    }
                }
                else {
                    completion(.failure(ApiError("Failed get key")))
                }
            }.resume()
        }
    }
    
    public func authenticate(username: String, password: String, apiKey: String, sessionDelegate: URLSessionDelegate,
                             completion: @escaping (Result<GetKey, ApiError>) -> Void)
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
                        completion(.failure(ApiError("Failed get key")))
                    }
                }
                else {
                    completion(.failure(ApiError("Failed get key")))
                }
            }.resume()
        }
    }
    
    public func fetchUserData(apiKey: String, sessionDelegate: URLSessionDelegate, completion: @escaping (Result<User, ApiError>) -> Void)
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
                        completion(.success(user))
                    }
                    catch {
                        completion(.failure(ApiError("Failed get user")))
                    }
                }
                else {
                    completion(.failure(ApiError("Failed get user")))
                }
            }.resume()
        }
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YWNhMDEwNmFlZThlY2U0ZDMwOThlNTcwNGQxZTJkMCIsInN1YiI6IjY1MTZkMGEzOTY3Y2M3MDBhY2I4NzJhZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.oQF0cgq58KX3nIam3qWauiK4iaG3B6IwhyNQkv7fsAQ", forHTTPHeaderField: "Authorization")
            completion(request)
        }
    }
}
