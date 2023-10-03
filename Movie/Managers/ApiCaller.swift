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
    
    public func getGenres(sessionDelegate: URLSessionDelegate, completion: @escaping (String) -> Void) {
        
        createRequest(with: URL(string: "https://api.themoviedb.org/3/genre/movie/list?language=en"), type: .GET) { request in
            print("22")
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: request) { data, _, error in
                if let data = data, error == nil {
                    print("22")
                    do{
                        let json = try JSONSerialization.jsonObject(with: data)
                        print(json)
                    }
                    catch {
                        print(error)
                    }
                    completion("OK")
                }
                else {
                    print(error)
                    completion("NOT OK")
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
