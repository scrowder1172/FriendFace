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
        Group {
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
                List {
                    ForEach(people) { person in
                        Section(person.id) {
                            Text(person.name)
                        }
                    }
                }
            case .peopleAndJSON(let people, _):
                List {
                    ForEach(people) { person in
                        Section(person.id) {
                            Text(person.name)
                        }
                    }
                }
            default:
                ContentUnavailableView {
                    Label("Default Switch", systemImage: "exclamationmark.triangle")
                } description: {
                    Text("Not really sure...")
                }
            }
        }
    }
}

#Preview {
    PeopleView(state: .constant(.ready))
}
