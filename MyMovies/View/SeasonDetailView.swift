//
//  SeasonDetailView.swift
//  MyMovies
//
//  Created by Philipp Dumke on 29.05.21.
//
import Combine
import SDWebImageSwiftUI
import SwiftUI

struct SeasonDetailView: View {
    let tvShow: TvShow
    let season: Season
    
    @State private var details: SeasonDetails?
    @State private var requests = Set<AnyCancellable>()
    @EnvironmentObject var dataContoller:DataController
    
    
    var displayedEpisodes: [Episode] {
        guard let episodes = details?.episodes else { return []}
        print("\(episodes.count) Items")
        return episodes
    }
    
    var body: some View {
        ScrollView{
            VStack{
                if let path = season.posterPath {
                    WebImage(url: URL(string: "https://image.tmdb.org/t/p/original\(path)"))
                        .placeholder{
                            Color.gray.frame(maxHeight: 200)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 200)
                }
                Text(details?.airDate ?? "")
                Text("Episode List")
                    .font(.headline)
                VStack(alignment: .leading){
                    ForEach(displayedEpisodes) { episode in
                        EpisodeView(episode: episode)
                    }
                }
                
            }
            .onAppear(perform: fetchDetails)
            .navigationTitle(season.name)
        }
    }
    func fetchDetails(){
        let seasonRequest = URLSession.shared.get(path: "tv/\(tvShow.id)/season/\(season.seasonNumber)", defaultValue: nil, api: dataContoller.apiKey){ downloaded in
            details = downloaded
        }
        if let seasonRequest = seasonRequest{requests.insert(seasonRequest)}
    }
}

struct EpisodeView: View {
    
    let episode: Episode
    @State private var expand = false
    
    var body: some View{
        VStack(alignment:.leading){
            HStack{
                VStack{
                WebImage(url: URL(string: "https://image.tmdb.org/t/p/original\(episode.stillPath)"))
                    .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                    .placeholder(Image(systemName: "photo")) // Placeholder Image
                        // Supports ViewBuilder as well
                    .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                    .indicator(.activity) // Activity Indicator
                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                    .scaledToFit()
                    .frame(width: 150, height: 90, alignment: .center)
                }
                
                VStack(alignment: .leading){
                    Text("\(episode.episodeNumber)")
                        .font(.subheadline)
                        .padding(.horizontal)
                    Text(episode.name ?? "" )
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(4)
                        .padding(.horizontal)
                    Text(episode.airDate ?? "")
                        .padding(.horizontal)
                }
            }
            if expand {
                Text(episode.overview ?? "")
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                    .padding()
            }
        }
        .onTapGesture {
            withAnimation(){
                self.expand.toggle()
            }
        }
    }
}
