//
//  PeopleView.swift
//  FriendFace
//
//  Created by SCOTT CROWDER on 11/30/23.
//

import SwiftUI

struct PeopleView: View {
    @Environment(DataController.self) var dataController
    
    @State private var filterActiveUsers: Bool = false
    
    var body: some View {
        NavigationStack() {
            Group {
                switch dataController.state {
                case .ready:
                    ContentUnavailableView {
                        Label("User Data Missing", systemImage: "person.3")
                    } description: {
                        Text("Click button to download users...")
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
                    PeopleListView()
                default:
                    ContentUnavailableView {
                        Label("Default Switch", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text("Not really sure...")
                    }
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
                    MenuSubView(dc: dataController)
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

struct MenuSubView: View {
    
    @Bindable var dc: DataController
    var body: some View {
        
        Menu("Sort", systemImage: "line.3.horizontal.decrease.circle") {
            Picker("Sort", selection: $dc.sortOption) {
                ForEach(DataController.SortOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
                .onChange(of: dc.sortOption) {
                    dc.sortPeople()
                }
            
            Button(dc.filterActiveUsers ? "Show Everyone" : "Show Active Users Only") {
                dc.filterActiveUsers.toggle()
            }
        }
        
        
    }
}

struct PeopleListView: View {
    
//    @Binding var dataController: DataController
    @Environment(DataController.self) var dataController
    
    @State private var isActiveExpanded: Bool = false
    @State private var isInactiveExpanded: Bool = false
    
    var body: some View {
        TextFieldSubView(dc: dataController)
        List {
            
            DisclosureGroup("Active", isExpanded: $isActiveExpanded) {
                ForEach(dataController.filteredPeople) { person in
                    if person.isActive {
                        NavigationLink {
                            PersonDetailView(person: person)
                        } label: {
                            HStack {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(person.isActive ? .green : .red)
                                Text(person.name)
                            }
                            
                        }
                    }
                }
            }
            if !dataController.filterActiveUsers {
                DisclosureGroup("Inactive", isExpanded: $isInactiveExpanded) {
                    ForEach(dataController.filteredPeople) { person in
                        if !person.isActive {
                            NavigationLink {
                                PersonDetailView(person: person)
                            } label: {
                                HStack {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(person.isActive ? .green : .red)
                                    Text(person.name)
                                }
                                
                            }
                        }
                    }
                }
            }
            
            
        }
    }
}

struct TextFieldSubView: View {
    @Bindable var dc: DataController
    var body: some View {
        TextField("user search", text: $dc.searchText)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
    }
}

struct PersonDetailView: View {
    
    @Environment(DataController.self) private var dc
    
    let person: Users
    
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
                        NavigationLink {
                            ForEach(dc.people) {person in
                                if friend.id == person.id {
                                    PersonDetailView(person: person)
                                }
                            }
                        } label: {
                            VStack {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                
                                Text(friend.name)
                                    .font(.caption)
                            }
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
    PeopleView()
        .environment(DataController())
}
