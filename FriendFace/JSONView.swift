//
//  JSONView.swift
//  FriendFace
//
//  Created by SCOTT CROWDER on 11/30/23.
//

import SwiftUI

struct JSONView: View {
    
    @Binding var dataController: DataController
    
    var body: some View {
        NavigationStack {
            Group {
                switch dataController.state {
                case .done:
                    UITextViewWrapper(text: dataController.json)
                default:
                    ContentUnavailableView {
                        Label("JSON Data", systemImage: "desktopcomputer.and.arrow.down")
                    } description: {
                        Text("No JSON Data Loaded Yet")
                    }
                }
            }
            .navigationTitle("JSON View")
        }
    }
}

#Preview {
    JSONView(dataController: .constant(DataController()))
}
