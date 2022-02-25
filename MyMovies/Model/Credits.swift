//
//  Credits.swift
//  MyMovies
//
//  Created by Philipp Dumke on 16.05.21.
//
/*
import Foundation

struct Credits: Decodable {
    let cast : [CastMember]
    let crew :  [CrewMember]
}

struct CastMember: Decodable, Identifiable {
    var id : String { creditId}
    let creditId: String
    let name: String
    let character: String
    let profilePath: String?
}

struct CrewMember: Decodable, Identifiable {
    var id : String { creditId}
    let creditId: String
    let name: String
    let job: String
    let profilePath: String?
}
*/

import Foundation
import SDWebImageSwiftUI
import SwiftUI

struct Credits: Decodable {
    let cast: [CastMember]
    let crew: [CrewMember]
}

struct CastMember: Decodable, Identifiable {
    var id: String { creditId }
    
    let creditId: String
    let name: String
    let character: String
    let profilePath: String?
    
    var image: some View {
        Group {
            if let path = profilePath {
                WebImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(path)"))
                    .placeholder {
                        Color.gray.frame(maxWidth: 150) }
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 150)
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 150)
            }
        }
    }
}


struct CrewMember: Decodable, Identifiable {
    var id: String { creditId }
    
    let creditId: String
    let name: String
    let job: String
    let profilePath: String?
    
    var image: some View {
        Group {
            if let path = profilePath {
                WebImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(path)"))
                    .placeholder {
                        Color.gray.frame(maxHeight: 150) }
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 150)
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 150)
            }
        }
    }
}
