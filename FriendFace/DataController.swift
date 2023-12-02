//
//  DataController.swift
//  FriendFace
//
//  Created by SCOTT CROWDER on 11/30/23.
//

import Foundation

enum LoadState {
    case failed(error: String), peopleFound([People]), ready, rawJSON(json: String), peopleAndJSON([People], json: String), loading, done
}

@Observable
final class DataController {
    
    var people: [People] = [People]()
    
    var json: String = ""
    
    var searchText: String = ""
    
    var state: LoadState = .ready
    
    var filteredPeople: [People] {
        if searchText.isEmpty {
            return people
        } else {
            return people.filter { $0.name.localizedStandardContains(searchText)}
        }
    }
    
    func loadJSON() async -> LoadState {
        let fullURL: String = "https://www.hackingwithswift.com/samples/friendface.json"
        
        guard let url: URL = URL(string: fullURL) else {
            return .failed(error: "URL invalid")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failed(error: "Unable to decode HTTP response")
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            let decoder: JSONDecoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodedPeople = try decoder.decode([People].self, from: data)
            
            guard let returnedJSON = String(data: data, encoding: .utf8) else {
                return .failed(error: "Unable to parse response string")
            }
            
            json = returnedJSON
            people = decodedPeople
            
            for person in people {
                print(person.name)
            }
            
            return .done
            
        } catch {
            print(error.localizedDescription)
            return .failed(error: error.localizedDescription)
        }
    }
}
