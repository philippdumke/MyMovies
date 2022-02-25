//
//  SeasonDetails.swift
//  MyMovies
//
//  Created by Philipp Dumke on 29.05.21.
//

import Foundation

struct SeasonDetails: Decodable{
    let id: Int
    let Id: String?
    let airDate: String?
    let episodes: [Episode]?
    let name: String?
    let overview: String?
    let seasonNumber: Int?
}


struct Episode: Decodable, Identifiable {
    let id:Int
    let airDate:String?
    let name: String?
    let overview: String?
    let stillPath: String
    let voteAverage: Double?
    let episodeNumber: Int
    
}
