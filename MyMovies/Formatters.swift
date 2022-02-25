//
//  Formatters.swift
//  MyMovies
//
//  Created by Philipp Dumke on 16.05.21.
//

import Foundation

enum Formatetrs {
    static let movieDecoding: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-m-d"
        return formatter
    }()
    
    static let movieDisplay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y"
        return formatter
    }()
}

