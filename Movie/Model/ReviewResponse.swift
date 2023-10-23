//
//  ReviewResponse.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 20.10.23.
//

import Foundation

struct ReviewResponse: Codable {
    let results: [Review]
}

struct Review: Codable {
    let author: String
    let content: String
    let author_details: Author
}

struct Author: Codable {
    let username: String
    let avatar_path: String?
    let rating: Int
}
