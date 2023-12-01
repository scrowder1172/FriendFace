//
//  JSONView.swift
//  FriendFace
//
//  Created by SCOTT CROWDER on 11/30/23.
//

import SwiftUI

struct JSONView: View {
    
    @Binding var state: LoadState
    
    var body: some View {
        NavigationStack {
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
    JSONView(state: .constant(.ready))
}
