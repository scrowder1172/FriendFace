//
//  PeopleView.swift
//  FriendFace
//
//  Created by SCOTT CROWDER on 11/30/23.
//

import SwiftUI

struct PeopleView: View {
    
    @Binding var state: LoadState
    
    var body: some View {
        NavigationStack {
            switch state {
            case .ready:
                ContentUnavailableView {
                    Label("JSON Data", systemImage: "person.3")
                } description: {
                    Text("Click button to load people...")
                }
            case .failed(let message):
                ContentUnavailableView {
                    Label("Load Results", systemImage: "exclamationmark.triangle")
                } description: {
                    Text("Error: \(message)")
                }
            case .loading:
                ProgressView("Loading...")
            case .peopleFound(let people):
                PeopleListView(people: people)
            case .peopleAndJSON(let people, _):
                PeopleListView(people: people)
            default:
                ContentUnavailableView {
                    Label("Default Switch", systemImage: "exclamationmark.triangle")
                } description: {
                    Text("Not really sure...")
                }
            }
            
            Text("")
                .navigationTitle("Friend Face")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Get People", systemImage: "arrow.down.doc") {
                            Task {
                                await retrieveJSONData()
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Remove People", systemImage: "trash") {
                            state = .ready
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("Sort", systemImage: "line.3.horizontal.decrease.circle") {
                            Text("Something soon...")
                            Text("Something soon...")
                            Text("Something soon...")
                            Text("Something soon...")
                        }
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

struct PeopleListView: View {
    
    let people: [People]
    
    @State private var searchText: String = ""
    
    var filteredPeople: [People] {
        if searchText.isEmpty {
            return people
        } else {
            return people.filter { $0.name.localizedStandardContains(searchText)}
        }
    }
    
    var body: some View {
        TextField("user search", text: $searchText)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
        List {
            ForEach(filteredPeople) { person in
                Section(person.id) {
                    NavigationLink {
                        PersonDetailView(person: person)
                    } label: {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(person.isActive ? .black : .red)
                            Text(person.name)
                                .font(.title).bold()
                        }
                        
                    }
                }
            }
        }
    }
}

struct PersonDetailView: View {
    
    let person: People
    
    var body: some View {
        VStack {
            Text(person.id)
            Text(person.name)
            Text(person.address)
            Text(person.registered.formatted(date: .long, time: .standard))
            
            List {
                ForEach(person.unwrappedFriends) { friend in
                    Text(friend.name)
                }
            }
        }
    }
}

#Preview {
    PeopleView(state: .constant(.ready))
}
