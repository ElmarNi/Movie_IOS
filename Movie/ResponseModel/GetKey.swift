//
//  GetKey.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 13.10.23.
//

import Foundation

struct GetKey: Codable {
    let expires_at: String
    let request_token: String
    let success: Bool
}
