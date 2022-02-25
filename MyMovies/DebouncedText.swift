//
//  DebouncedText.swift
//  MyMovies
//
//  Created by Philipp Dumke on 16.05.21.
//
import Combine
import Foundation


class DebouncedText: ObservableObject {
    @Published var text = ""
    @Published var debouncedText = ""
    
    private var textDebounce: AnyCancellable?
    
    init() {
        textDebounce = $text
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink{
                self.debouncedText = $0
            }
    }
}
