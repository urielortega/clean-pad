//
//  LockedNotesListView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 20/09/23.
//

import SwiftUI

/// View that contains locked notes, and let users tap a note to view and edit it.
struct LockedNotesListView: View {
    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    
    @Binding var showEditViewSheet: Bool
    @State private var isAnimating = false

    var body: some View {
        Group {
            if viewModel.isUnlocked {
                if viewModel.lockedNotes.isEmpty {
                    EmptyListView(
                        imageSystemName: "note.text",
                        label: "This looks a little empty...",
                        description: viewModel.placeholders.randomElement() ?? "Start writing...",
                        buttonLabel: "Create a note!"
                    ) {
                        showEditViewSheet.toggle()
                    }
                    .padding(.bottom, 80)
                } else {
                    VStack {
                        Form {
                            List {
                                ForEach(viewModel.lockedNotes) { note in
                                    NavigationLink {
                                        // Open NoteEditView with the tapped note.
                                        NoteEditView(note: note, viewModel: viewModel, creatingNewNote: false)
                                    } label: {
                                        VStack(alignment: .leading) {
                                            Text(note.title)
                                            Text(note.date.formatted(date: .abbreviated, time: .shortened))
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .contextMenu {
                                            // Button to change isLocked note property, i.e., remove it from the personal space.
                                            Button {
                                                viewModel.updateLockStatus(for: note)
                                            } label: {
                                                Label("Remove from personal space", systemImage: "lock.open.fill")
                                            }
                                        }
                                    }
                                }
                                .onDelete(perform: viewModel.removeLockedNoteFromList)
                            }
                        }
                        
                        // View to prevent CustomTabBar from hiding the List.
                        Color.clear
                            .frame(height: 40)
                    }
                }
            } else {
                unlockNotesButtonView
            }
        }
    }
    
    /// Button to authenticate and show locked notes list.
    var unlockNotesButtonView: some View {
        Button {
            viewModel.authenticate(for: .viewNotes) {  }
        } label: {
            ZStack {
                Capsule()
                    .foregroundStyle(.brown)
                    .frame(width: 200, height: 50)

                Text("Unlock Notes")
                    .foregroundColor(.white)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .opacity(isAnimating ? 0.8 : 1.0)
        .scaleEffect(isAnimating ? 0.95 : 1.0)
        .onAppear {
            DispatchQueue.main.async {
                // Using withAnimation() to avoid unintentional movement:
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isAnimating.toggle()
                }
            }
        }
    }
}
