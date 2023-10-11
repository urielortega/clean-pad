//
//  MainNotesListView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 20/09/23.
//

import SwiftUI

struct MainNotesListView: View {
    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    
    @Binding var showEditViewSheet: Bool

    var body: some View {
        Form {
            // Locked notes section.
            Section {
                NavigationLink {
                    LockedNotesListView(viewModel: viewModel)
                } label: {
                    Label(
                        "Personal notes", 
                        systemImage:viewModel.isUnlocked ? "lock.open.fill" : "lock.fill"
                    )
                    .foregroundColor(.brown)
                }
            }
            
            // Non-locked notes section.
            Section {
                if viewModel.nonLockedNotes.isEmpty {
                    // FIXME: Temporal solution to center EmptyListView.
                    HStack {
                        Spacer()
                        
                        EmptyListView(
                            imageSystemName: "note.text",
                            label: "This looks a little empty...",
                            description: viewModel.placeholders.randomElement() ?? "Start writing...",
                            buttonLabel: "Create a note!"
                        ) {
                            showEditViewSheet.toggle()
                        }
                        
                        Spacer()
                    }
                    .padding()
                } else {
                    NonLockedNotesListView(viewModel: viewModel)
                }
            }
        }
    }
}
