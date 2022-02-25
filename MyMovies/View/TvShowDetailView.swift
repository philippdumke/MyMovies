//
//  TvShowDetailView.swift
//  MyMovies
//
//  Created by Philipp Dumke on 29.05.21.
//
import SDWebImageSwiftUI
import Combine
import SwiftUI

struct TvShowDetailView: View {
    let tvShow: TvShow
    
    @State private var details : TVShowDetails?
    @State private var requests = Set<AnyCancellable>()
    @EnvironmentObject var dataController: DataController
    
    var displayedSeasons: [Season] {
        guard let seasons = details?.seasons else {return []}
        return seasons
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                VStack(alignment: .leading, spacing: 0){
                    
                    if let path = tvShow.backdropPath {
                        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w1280\(path)"))
                            .placeholder{
                                Color.gray.frame(maxHeight: 200)
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 200)
                        
                    }
                    if let details = details {
                        HStack(spacing: 20){
                            Text("Seasons: \(details.numberOfSeasons)")
                            Text("\(details.numberOfEpisodes) Episodes")
                        }
                        .foregroundColor(.white)
                        .font(.caption.bold())
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .background(Color.black)
                    }
                }
                
                Text(tvShow.overview)
                    .padding([.horizontal, .bottom])
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                
                //MARK: Seasons
                Text("Seasons")
                    .font(.subheadline)
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(displayedSeasons){season in
                            NavigationLink(destination: SeasonDetailView(tvShow: tvShow, season: season)){
                                VStack{
                                    season.posterImage
                                    Text(season.name)
                                    Text(season.formattedAirDate)
                                    Text("Episods: \(season.episodes)")
                                }
                                .padding(.bottom)
                            }
                        }
                    }
                }
                
        }
        .onAppear(perform: fetchTvShowDetails)
        .navigationTitle(tvShow.name)
        .navigationBarTitleDisplayMode(.inline)
        }
    }
    func fetchTvShowDetails() {
        
        //Creates a Request to fetch the Movie Details
        let tvShowRequest = URLSession.shared.get(path: "tv/\(tvShow.id)", defaultValue: nil, api: dataController.apiKey){downloaded in
            details = downloaded
        }
        if let tvShowRequest = tvShowRequest{requests.insert(tvShowRequest)}
    }
}

struct TvShowDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TvShowDetailView(tvShow: TvShow.example)
    }
}
