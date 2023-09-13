//
//  ContentView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/09/23.
//

import SwiftUI

struct ContentView: View {
    // Creating shared viewModel with @StateObject.
    @StateObject var viewModel = NotesListViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.notes.isEmpty {
                    HStack {
                        Text(viewModel.placeholders.randomElement() ?? "Start writing...")
                            .font(.system(size: 60))
                            .fontWeight(.black)
                            .fontDesign(.serif).italic()
                            .foregroundColor(.brown.opacity(0.3))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding()
                    .onTapGesture {
                        // TODO: Create note.
                    }
                } else {
                    List(viewModel.notes) { note in
                        Text(note.title)
                    }
                }
            }
            .navigationTitle("CleanPad")
            .toolbar {
                ToolbarItem {
                    Button {
                        // TODO: Create note
                    } label: {
                        Label("Create note", systemImage: "plus")
                    }

                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
