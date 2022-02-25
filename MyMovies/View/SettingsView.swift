//
//  SettingsView.swift
//  MyMovies
//
//  Created by Philipp Dumke on 25.02.22.
//

import SwiftUI


struct SettingsView: View {

    @EnvironmentObject var dataController:DataController
    @Environment(\.presentationMode) var presentationMode
    @State private var apiKey:String

    init(apiKey:String){
        _apiKey = State(initialValue: apiKey)
    }

    var body: some View {
        VStack{
            Spacer()
            Text("Please enter your api Key from themoviedb.org")
            TextField("api Key", text: self.$apiKey)
                .font(.footnote)
                .padding()
            Button("Save", action: save)
            Spacer()
        }

    }
    func save() {
        dataController.apiKey = self.apiKey
        dataController.saveApiKey()
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(apiKey: "cda44c1249")
    }
}
