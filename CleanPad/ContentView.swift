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
        ZStack {
            NavigationStack {
                Group {
                    if viewModel.notes.isEmpty {
                        EmptyListView(viewModel: viewModel)
                    } else {
                        NotesListView(viewModel: viewModel)
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
            
            BackgroundView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct EmptyListView: View {
    // Using the viewModel in a different view with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    
    var body: some View {
        Button {
            // TODO: Create note
        } label: {
            HStack {
                Text(viewModel.placeholders.randomElement() ?? "Start writing...")
                    .font(.system(size: 60))
                    .fontWeight(.black)
                    .fontDesign(.serif).italic()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
            }
            .padding()
        }
    }
}

struct BackgroundView: View {
    var body: some View {
        Color.brown
            .opacity(0.2)
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}

struct NotesListView: View {
    // Using the viewModel in a different view with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    
    var body: some View {
        List(viewModel.notes) { note in
            NavigationLink {
                Text(note.title) // FIXME: Just for testing purposes. Change later.
            } label: {
                VStack(alignment: .leading) {
                    Text(note.title)
                    Text(note.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

        }
    }
}
