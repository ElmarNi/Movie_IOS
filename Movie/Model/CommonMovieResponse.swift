//
//  CommonMovie.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 05.10.23.
//

import Foundation

struct CommonMovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
