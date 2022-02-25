//
//  MovieDetailsView.swift
//  MyMovies
//
//  Created by Philipp Dumke on 16.05.21.
//
import SDWebImageSwiftUI
import Combine
import SwiftUI

struct MovieDetailsView: View {
    
    let movie: Movie
    
    @EnvironmentObject var dataController : DataController
    
    @State private var details : MovieDetails?

    @State private var credits : Credits?
    @State private var reviews = [Review]()
    @State private var reviewtext = ""
    
    
    var reviewURL: URL? {
        URL(string: "https://www.hackingwithswift.com/sample\(movie.id)")
    }
    @State private var showingAllCast = false
    @State private var showingAllCrew = false
    @State private var requests = Set<AnyCancellable>()
    
    
    var displayedCast: [CastMember] {
        guard let credits = credits else { return [] }
        return credits.cast
    }
    
    var displayedCrew: [CrewMember] {
        guard let credits = credits else { return [] }
        return credits.crew
        
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                VStack(alignment: .leading, spacing: 0){
                    
                    if let path = movie.backdropPath {
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
                        Text("Revenue: $\(details.revenue)")
                        Text("\(details.runtime) minutes")
                    }
                    .foregroundColor(.white)
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background(Color.black)
                    }
                }
                
                ScrollView(.horizontal, showsIndicators:false){
                    HStack(spacing: 3){
                        ForEach(movie.genres){genre in
                            Text(genre.name)
                                .font(.body)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 2)
                                .background(Color(genre.color))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 10)
                }
                Text(movie.overview)
                    .padding([.horizontal, .bottom])
                
                
                //MARK: Cast
                Text("Cast")
                    .font(.title)
                ScrollView (.horizontal){
                    HStack(alignment: .top , spacing: 10){
                        ForEach(displayedCast){ cast in
                            VStack(alignment:.center, spacing: 0){
                                cast.image
                                    .clipShape(Circle())
                                    Spacer()
                                Text(cast.name)
                                    .lineLimit(2)
                                Text(cast.character)
                                    .font(.footnote)
                            }
                            .frame(width: 110, height: 220)
                        }
                    }
                }
                //MARK: CREW
                Text("crew")
                    .font(.title)
                ScrollView (.horizontal){
                    HStack(spacing: 10){
                        ForEach(displayedCrew){ cast in
                            VStack(alignment:.center, spacing: 0){
                                cast.image
                                    .clipShape(Circle())
                                Text(cast.name)
                                Text(cast.job)
                                    .font(.footnote)
                            }
                            .frame(width: 110, height: 220)
                        }
                    }
                }
                /*
                VStack{
                    Text("Reviews")
                        .font(.title)
                    
                    ForEach(reviews) { review in
                        Text(review.text)
                            .font(.body.italic())
                    }
                    
                    TextEditor(text: $reviewtext)
                        .frame(height: 200)
                        .border(Color.gray, width: 1)
                    
                    Button("Submit Review", action: submitReview)
                        .padding(.bottom)
                }
                /// -----------*/
            }
            .toolbar{
                Button {
                    dataController.toggleFavorite(movie)
                } label: {
                    if dataController.isFavorite(movie) {
                        Image(systemName: "heart.fill")
                    } else {
                        Image(systemName: "heart")
                    }
                }
            }
        }
        .onAppear(perform: fetchMovieDetails)
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
    func fetchMovieDetails() {
        let movieRequest = URLSession.shared.get(path: "movie/\(movie.id)", defaultValue: nil, api: dataController.apiKey){downloaded in
            details = downloaded
        }
        
        let creditsRequest = URLSession.shared.get(path: "movie/\(movie.id)/credits", defaultValue: nil, api: dataController.apiKey){downloaded in
            credits = downloaded
        }
        
        if let movieRequest = movieRequest {requests.insert(movieRequest)}
        if let creditsRequest = creditsRequest {requests.insert(creditsRequest)}
        
        guard let reviewURL = reviewURL else { return }

        let reviewsRequest = URLSession.shared.fetch(reviewURL, defaultValue: []) { downloaded in
            reviews = downloaded
        }

        requests.insert(reviewsRequest)
        
    }
    
    func submitReview() {
        guard reviewtext.isEmpty  == false else { return }
        guard let reviewURL = reviewURL else  { return }
        
        let review = Review(id: UUID().uuidString, text: reviewtext)
        let request = URLSession.shared.post(review, to: reviewURL) { result in
            if result == "OK" {
                reviews.append(review)
                reviewtext = ""
            }
        }

        requests.insert(request)
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MovieDetailsView(movie: Movie.example)
        }
    }
}
