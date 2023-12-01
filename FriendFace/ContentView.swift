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
    
    @State private var dataController: DataController = DataController()
    
    var body: some View {
        
        TabView {
            PeopleView(state: $state, dataController: $dataController)
            .tabItem { Label("People", systemImage: "person.3") }
            
            JSONView(state: $state)
            .tabItem { Label("JSON", systemImage: "plus")}
        }
    }
}

#Preview {
    ContentView()
}
