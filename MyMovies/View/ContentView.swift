import Combine
import SwiftUI

//
// TMDb asks you to register for an API key to use their
// service, and it's free as long as you provide attribution.
// You can learn more and apply for your own API key here:
// https://www.themoviedb.org/documentation/api
//

struct ContentView: View {
    @State private var seachResults = SearchResults(results: [])
    @State private var searchResultsTV = SearchResultsTV(results: [])
    @StateObject private var search = DebouncedText()
    @State private var request: AnyCancellable?
    @State private var tvRequest: AnyCancellable?
    @State private var pickervalue = 0
    @EnvironmentObject var dataController:DataController
    @State private var showsheet: Bool = false

    
    var body: some View {
        NavigationView{
            List{
                Section(header:
                        VStack{
                            TextField ("Seach for a movie...", text: $search.text)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textCase(.none)
                            Picker(selection: $pickervalue, label: Text("")) {
                                    Text("Movie").tag(0)
                                    Text("TV").tag(1)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                        }
                ){
                    if pickervalue == 0 {
                        ForEach(seachResults.results, content: MovieRow.init)
                    }else{
                        ForEach(searchResultsTV.results, content: TVRow.init)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("MyMovies")
            .onChange(of: search.debouncedText, perform: runSearch)
            .toolbar{
                Button{
                    self.showsheet.toggle()
                }label:{
                    Image(systemName: "gear")
                }

            }
            .onAppear(){
                if dataController.apiKey == "" {
                    showsheet = true
                }
            }
        }
        .sheet(isPresented: $showsheet) {
            SettingsView(apiKey: dataController.apiKey)
        }
    }
    
    func runSearch(criteria: String) {
        request?.cancel()
        request = URLSession.shared.get(path: "search/movie",queryItems: ["query": criteria], defaultValue: SearchResults(results: []), api: dataController.apiKey) { items in
            seachResults = items
        }
        tvRequest?.cancel()
        tvRequest = URLSession.shared.get(path: "search/tv", queryItems : ["query": criteria], defaultValue: SearchResultsTV(results: []), api: dataController.apiKey) { items in
            searchResultsTV = items
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
