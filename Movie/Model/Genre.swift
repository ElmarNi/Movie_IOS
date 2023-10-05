//
//  Genre.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 05.10.23.
//

import Foundation

struct Genres: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
