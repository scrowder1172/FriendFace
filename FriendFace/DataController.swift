//
//  DataController.swift
//  FriendFace
//
//  Created by SCOTT CROWDER on 11/30/23.
//

import Foundation

enum LoadState {
    case failed(error: String), peopleFound([People]), ready, rawJSON(json: String), peopleAndJSON([People], json: String), loading
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
