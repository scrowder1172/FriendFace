//
//  PeopleView.swift
//  FriendFace
//
//  Created by SCOTT CROWDER on 11/30/23.
//

import SwiftUI

struct PeopleView: View {
    @Binding var dataController: DataController
    
    @State private var filterActiveUsers: Bool = false
    
    var body: some View {
        NavigationStack {
            switch dataController.state {
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
            case .done:
                PeopleListView(dataController: $dataController)
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
                        dataController.state = .ready
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Sort", systemImage: "line.3.horizontal.decrease.circle") {
                        Picker("Sort", selection: $dataController.sortOption) {
                            ForEach(DataController.SortOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .onChange(of: dataController.sortOption) {
                            dataController.sortPeople()
                        }
                        
                        Button(dataController.filterActiveUsers ? "Show Everyone" : "Show Active Users Only") {
                            dataController.filterActiveUsers.toggle()
                        }
                    }
                }
            }
        }
        
    }
    
    func retrieveJSONData() async {
        
        dataController.state = .loading
        
        Task {
            try await Task.sleep(for: .seconds(0.5))
            
            dataController.state = await dataController.loadJSON()
        }
        
    }
}

struct PeopleListView: View {
    
    @Binding var dataController: DataController
    
    var body: some View {
        TextField("user search", text: $dataController.searchText)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
        List {
            ForEach(dataController.filteredPeople) { person in
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
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        VStack {
            Image(systemName: "face.smiling")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
            
            VStack(alignment: .leading) {
                Text(person.name)
                    .font(.title)
                
                
                Text(person.address)
                    .font(.callout)
                
                Text(person.registered.formatted(date: .abbreviated, time: .standard))
                    .font(.callout)
            }
            
            
            ScrollView {
                LazyVGrid (columns: columns) {
                    ForEach(person.unwrappedFriends) { friend in
                        VStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                            
                            Text(friend.name)
                                .font(.caption)
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(.cyan)
                    }
                }
            }
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    PeopleView(dataController: .constant(DataController()))
}
