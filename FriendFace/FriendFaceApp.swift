//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by SCOTT CROWDER on 11/30/23.
//

import SwiftUI

@main
struct FriendFaceApp: App {
    
    @State private var dataController: DataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataController)
        }
    }
}
