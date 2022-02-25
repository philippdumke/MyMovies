//
//  TVRow.swift
//  MyMovies
//
//  Created by Philipp Dumke on 29.05.21.
//
import SDWebImageSwiftUI
import SwiftUI

struct TVRow: View {
    let tvShow: TvShow
    
    var posterImage: some View {
        Group {
            if let path = tvShow.posterPath {
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
        NavigationLink(destination: TvShowDetailView(tvShow: tvShow)){
            HStack{
                posterImage
                
                VStack(alignment: .leading) {
                    Text(tvShow.name)
                        .font(.title2)
                    
                    HStack{
                        Text("Rating: \(tvShow.voteAverage, specifier: "%g") /10")
                        Text(tvShow.formattedReleaseDate)
                    }
                    .font(.subheadline)
                    
                    Text(tvShow.overview)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .font(.body.italic())
                }
                
            }
        }
    }
}

struct TVRow_Previews: PreviewProvider {
    static var previews: some View {
        TVRow(tvShow: TvShow.example)
    }
}
