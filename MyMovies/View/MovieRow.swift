//
//  MovieRow.swift
//  MyMovies
//
//  Created by Philipp Dumke on 16.05.21.
//
import SDWebImageSwiftUI
import SwiftUI

struct MovieRow: View {
    let movie: Movie
    
    
    var posterImage: some View {
        Group {
            if let path = movie.posterPath {
                WebImage(url:URL(string: "https://image.tmdb.org/t/p/w342\(path)"))
                    .placeholder(Image("Loading").resizable())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 90)
            }else{
                Image("NoPoster")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 90)
            }
        }
    }
    
    var body: some View {
        NavigationLink(destination: MovieDetailsView(movie: movie)){
            HStack{
                posterImage
                
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.title2)
                    
                    HStack{
                        Text("Rating: \(movie.voteAverage, specifier: "%g") /10")
                        Text(movie.formattedReleaseDate)
                    }
                    .font(.subheadline)
                    
                    Text(movie.overview)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .font(.body.italic())
                }
                
            }
        }
    }
}

struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        MovieRow(movie: Movie.example)
    }
}
