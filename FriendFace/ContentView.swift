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
                    .tabItem { Label("People", systemImage: "person.3") }
                
                Group {
                        switch state {
                        case .rawJSON(let jsonData):
                            ScrollView {
                                Text(jsonData)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                            }
                        case .peopleAndJSON(_, let jsonData):
                            UITextViewWrapper(text: jsonData)
                        default:
                            Text("No JSON data")
                        }
                    }
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
        let dc = DataController()
        
        state = await dc.loadJSON()
    }
}

struct UITextViewWrapper: UIViewRepresentable {
    // this view is used to display large amounts of text like JSON response
    var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        // Configure other UITextView properties here
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}


@Observable
final class DataController {
    
    func loadJSON() async -> LoadState {
        let fullURL: String = "https://www.hackingwithswift.com/samples/friendface.json"
        
        guard let url: URL = URL(string: fullURL) else {
            return .failed(error: "URL invalid")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            guard let responseString = String(data: data, encoding: .utf8) else {
                return .failed(error: "Unable to parse response string")
            }
            
            //print("Raw JSON: \n\(responseString)")
            
            let decoder: JSONDecoder = JSONDecoder()
            let people = try decoder.decode([People].self, from: data)
            
            for person in people {
                print(person.name)
            }
            
//            return .peopleFound(people)
//            return .rawJSON(json: responseString)
            return .peopleAndJSON(people, json: responseString)
            
        } catch {
            print(error.localizedDescription)
            return .failed(error: error.localizedDescription)
        }
    }
}

enum LoadState {
    case failed(error: String), peopleFound([People]), ready, rawJSON(json: String), peopleAndJSON([People], json: String)
}

struct People: Codable, Identifiable {
    var id: String
    var name: String
}

#Preview {
    ContentView()
}
