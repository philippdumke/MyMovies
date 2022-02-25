//
//  MovieDetails.swift
//  MyMovies
//
//  Created by Philipp Dumke on 16.05.21.
//
import SDWebImageSwiftUI
import SwiftUI
import Foundation

struct MovieDetails : Decodable {
    let budget: Int
    let revenue: Int
    let runtime: Int
}

struct TVShowDetails: Decodable {
    let numberOfSeasons: Int
    let numberOfEpisodes: Int
    let seasons: [Season]?
}

struct Season: Decodable, Identifiable {
    let id: Int
    let airDate: String?
    let episodeCount: Int?
    let name: String
    let overview: String
    let posterPath: String?
    let seasonNumber: Int
    
    var episodes:String {
        guard let episodes  = episodeCount else {return ""}
        return String(episodes)
    }
    var posterImage: some View {
        Group {
            if let path = posterPath {
                WebImage(url:URL(string: "https://image.tmdb.org/t/p/w342\(path)"))
                    .placeholder(Image("Loading").resizable())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 130)
            }else{
                Image("NoPoster")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 130)
            }
        }
    }
    var formattedAirDate : String {
        guard airDate?.isEmpty == false else { return "" }
        if let date = Formatetrs.movieDecoding.date(from: airDate!){
            return Formatetrs.movieDisplay.string(from: date)
        }else{
            return ""
        }
    }
    
}
