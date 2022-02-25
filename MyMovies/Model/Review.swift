//
//  Review.swift
//  MyMovies
//
//  Created by Philipp Dumke on 16.05.21.
//

import Foundation


struct Review: Codable, Identifiable {
    let id: String
    let text: String
}
