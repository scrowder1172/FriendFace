//
//  ContentView.swift
//  FriendFace
//
//  Created by SCOTT CROWDER on 11/30/23.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    @State private var state: LoadState = .ready
    
    @State private var rawJSONData: String = "raw json data"
    
    var body: some View {
        NavigationStack {
            
            TabView {
                PeopleView(state: $state)
                    .tabItem { Label("People", systemImage: "person.3") }
                
                JSONView(state: $state)
                    .tabItem { Label("JSON", systemImage: "plus")}
            }
            .navigationTitle("Friend Face")
            .toolbar {
                Button("Get People", systemImage: "plus") {
                    Task {
                        await retrieveJSONData()
                    }
                }
                
                Button("Remove People", systemImage: "trash") {
                    state = .ready
                }
                
            }
        }
        
    }
    
    func retrieveJSONData() async {
        let dc: DataController = DataController()
        
        state = .loading
        
        Task {
            try await Task.sleep(for: .seconds(0.5))
            
            state = await dc.loadJSON()
        }
        
    }
}

#Preview {
    ContentView()
}
