//
//  DataController.swift
//  MyMovies
//
//  Created by Philipp Dumke on 16.05.21.
//
import CoreData
import Foundation
import SwiftUI

class DataController: ObservableObject {
    let defaults = UserDefaults.standard
    public var apiKey:String


    let container: NSPersistentContainer


    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Main")
        
        if inMemory{
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription).")
            }
            
        }
        apiKey =  defaults.string(forKey:"apiKey") as? String ?? ""
        print("inital Api Key Value \(apiKey)")
        
    }

    func saveApiKey() {
        defaults.set(apiKey, forKey: "apiKey")
    }

    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func fetchRequest(for movie: Movie) -> NSFetchRequest<SavedMovie> {
        let fetchRequest: NSFetchRequest<SavedMovie> = SavedMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
        return fetchRequest
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        let fetchRequest = fetchRequest(for: movie)
        let count = (try? container.viewContext.count(for: fetchRequest)) ?? 0
        return count > 0 
    }
    
    func toggleFavorite(_ movie: Movie){
        objectWillChange.send()
        let fetchRequest = fetchRequest(for: movie)
        fetchRequest.fetchLimit = 1
        
        let matchingItems = try? container.viewContext.fetch(fetchRequest)
        
        if let firstItem = matchingItems?.first {
            container.viewContext.delete(firstItem)
        }else{
            let savedMovie  = SavedMovie(context: container.viewContext)
            
            savedMovie.id = Int32(movie.id)
            savedMovie.title = movie.title
            savedMovie.overview = movie.overview
            savedMovie.releaseDate = movie.releaseDate
            savedMovie.voteAverage = movie.voteAverage
            savedMovie.posterPath = movie.posterPath
            savedMovie.backdropPath = movie.backdropPath
            savedMovie.genres = movie.genreIds.map(String.init).joined(separator: ",")
        }
        save()
    }
}


