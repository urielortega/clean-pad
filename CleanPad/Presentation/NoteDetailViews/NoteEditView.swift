//
//  NoteEditView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 19/09/23.
//

import AlertKit
import SwiftUI

/// Enum for controlling the focus state when creating or editing a note.
fileprivate enum FocusField: Hashable {
    case titleTextField
    case textEditorField
}

/// View that shows a note content allowing the user to modify it, update it, save it and lock the note itself.
struct NoteEditView: View {
    /// A modifiable copy of the note used for editing.
    @State private var noteCopy: Note
    
    /// A property for storing the original note, used to detect changes.
    private let originalNote: Note

    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    /// Property to show Cancel and Save buttons, and handle `onChange` closures.
    @State var creatingNewNote: Bool
    
    /// Property to control the displaying of a note whose 'isLocked' property was recently toggled.
    @State var editingAToggledNote: Bool = false
    
    /// Property that determines whether an `AlertAppleMusic17View` is displayed to inform the user that a note has been successfully created.
    @State var isAlertPresented: Bool = false
    
    /// An `AlertAppleMusic17View` instance configured to display a success message when a note is created.
    let alertView = AlertAppleMusic17View(title: "Note created!", subtitle: nil, icon: .done)
    
    /// Property that stores the focus of the current text field.
    @FocusState private var focusedField: FocusField?
    
    @Environment(\.dismiss) var dismiss
    
    /// Property to adapt the UI for VoiceOver users.
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    /// Property to modify access to locked notes when phase changes.
    @Environment(\.scenePhase) private var scenePhase
    
    // Flag indicating whether the note's title or content has been modified, which triggers an update to the modification date.
    @State private var willDateBeUpdated = false
    
    /// State property to hold a random String from `untitledNotePlaceholders`.
    @State private var randomPlaceholder: String = ""
    
    init(
        note: Note,
        viewModel: NotesListViewModel,
        sheetsViewModel: SheetsViewModel,
        creatingNewNote: Bool
    ) {
        _noteCopy = State(initialValue: note)
        self.originalNote = note

        self.viewModel = viewModel
        self.sheetsViewModel = sheetsViewModel
        self.creatingNewNote = creatingNewNote
    }
    
    var body: some View {
        NavigationStack {
            // Show UnlockNotesView only when...
            if ( // ...access is locked, the note is private, it isn't a new one and the 'isLocked' property wasn't recently toggled.
                !viewModel.isUnlocked && (noteCopy.isLocked == true) && !creatingNewNote && !editingAToggledNote
            ) {
                Group {
                    if voiceOverEnabled {
                        UnlockNotesView(viewModel: viewModel).accessibilityUnlockNotesView
                    } else {
                        UnlockNotesView(viewModel: viewModel)
                    }
                }
                .padding(.bottom, 80)
            } else {
                VStack(spacing: .zero) {
                    titleTextFieldView
                        .padding(.vertical)
                    
                    Divider()
                    textContentTextEditorView
                    Divider()
                    
                    changeNoteCategoryView
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        if creatingNewNote {
                            Button("Cancel") { dismiss() }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            if !(focusedField == .none) {
                                Button("OK") { focusedField = .none } // Button to dismiss keyboard when typing.
                            } else {
                                Menu {
                                    isLockedToggleButtonView
                                    if !creatingNewNote {
                                        ShareLink(item: "\(noteCopy.noteTitle)\n\(noteCopy.noteContent)")
                                        DeleteNoteButton(
                                            note: noteCopy,
                                            viewModel: viewModel,
                                            dismissView: true
                                        )
                                    }
                                    
                                } label: {
                                    Label("More options", systemImage: "ellipsis.circle")
                                }
                                if creatingNewNote {
                                    saveNoteButtonView
                                }
                            }
                        }
                    }
                }
                .sheet(isPresented: $sheetsViewModel.showNoteCategorySheet) {
                    NoteCategorySelectionView(
                        note: $noteCopy,
                        creatingNewNote: $creatingNewNote,
                        viewModel: viewModel,
                        sheetsViewModel: sheetsViewModel
                    )
                }
                .blurWhenAppNotActive(isBlurActive: noteCopy.isLocked) // Apply blur when the current note is private.
            }
        }
        .onAppear {
            // Only set `randomDescription` once per appearance of the view
            if randomPlaceholder.isEmpty {
                randomPlaceholder = NoteEditView.untitledNotePlaceholders.randomElement() ?? "Title your note..."
            }
        }
        .onDisappear {
            // Update only if editing an existing note:
            if !creatingNewNote {
                viewModel.update(
                    note: noteCopy,
                    // Date is only updated when 'noteTitle' or 'noteContent' has changed.
                    updatingDate: willDateBeUpdated
                )
            }
        }
        .onChange(of: scenePhase) { phase, _ in
            if (phase == ScenePhase.background) { // When on background phase...
                editingAToggledNote = false // ...toggle 'editingAToggledNote', so the contents of the current private note can be hidden.

                if !creatingNewNote { // Update only if editing an existing note.
                    viewModel.update(
                        note: noteCopy,
                        // Date is only updated when 'noteTitle' or 'noteContent' has changed.
                        updatingDate: willDateBeUpdated
                    )
                }
            }
        }
        .onChange(of: noteCopy) {
            // Return early if the willDateBeUpdated flag is already true.
            if willDateBeUpdated {
                return
            } else {
                // If the note title or content changes...
                if (noteCopy.noteTitle != originalNote.noteTitle) || (noteCopy.noteContent != originalNote.noteContent) {
                    // ...its date will be updated.
                    willDateBeUpdated = true
                }
            }
            
            // Check if the app is running on macOS or iPadOS to apply real-time saving.
            if ProcessInfo.processInfo.isiOSAppOnMac || viewModel.idiom == .pad {
                // Swift Concurrency (Task) to introduce a non-blocking delay before saving:
                Task {
                    try await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec delay
                    
                    // Save the note after the delay:
                    viewModel.update(
                        note: noteCopy,
                        // Date is only updated when 'noteTitle' or 'noteContent' has changed.
                        updatingDate: willDateBeUpdated
                    )
                }
            }
        }
        .presentationCornerRadius(Constants.roundedRectCornerRadius)
        .alert(isPresent: $isAlertPresented, view: alertView)
        .alert("Authentication error", isPresented: $viewModel.isShowingAuthenticationErrorWhenEditing) {
            Button("OK") { }
        } message: { Text(viewModel.authenticationError) }
    }
}

// MARK: - Extension to group secondary views in NoteEditView.
extension NoteEditView {
    var titleTextFieldView: some View {
        TextField(
            noteCopy.noteTitle,
            text: $noteCopy.noteTitle,
            prompt: Text(randomPlaceholder)
        )
        .font(.title2).bold()
        .padding(.leading)
        .focused($focusedField, equals: .titleTextField)
        .onAppear {
            if creatingNewNote { focusedField = .titleTextField }
        }
        .onSubmit { focusedField = .textEditorField }
        .submitLabel(.next)
    }
    
    var textContentTextEditorView: some View {
        TextEditor(text: $noteCopy.noteContent)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .padding(.horizontal)
            .focused($focusedField, equals: .textEditorField)
    }
    
    /// Button to toggle `isLocked` property of a note, i.e., move it to or remove it from the private space.
    var isLockedToggleButtonView: some View {
        Button {
            viewModel.authenticate(for: .changeLockStatus) {
                noteCopy.isLocked.toggle()
                editingAToggledNote = true // 'isLocked' property was recently toggled.
            }
        } label: {
            Label(
                !noteCopy.isLocked ? "Move to private space" : "Remove from private space",
                systemImage: !noteCopy.isLocked ? "lock.fill" : "lock.slash.fill"
            )
        }
    }
    
    /// Button for saving a new note by adding it to the ViewModel's notes array.
    var saveNoteButtonView: some View {
        Button("Save") {
            viewModel.add(note: noteCopy)
            dismiss()
            
            HapticManager.instance.notification(type: .success)
            isAlertPresented.toggle()
        }
    }
    
    /// A view for displaying and changing the category of a note.
    /// It shows the current category of the note, along with a "Change Category" button that allows users to select a new category.
    var changeNoteCategoryView: some View {
        HStack {
            HStack {
                // Circular indicator showing the color of the current category:
                Circle()
                    .fill((noteCopy.category?.color ?? .gray).gradient)
                    .frame(width: 10, height: 10)
                
                // Name of the selected category:
                Text(noteCopy.category?.displayName ?? "No Category Selected")
                    .bold(noteCopy.category == nil ? false : true)
                    .foregroundStyle(noteCopy.category == nil ? .gray : Color(.label))
                    .lineLimit(1)
            }
            .accessibilityElement()
            .accessibilityLabel("Category: \(noteCopy.category?.displayName ?? "Unassigned").")
            
            Spacer()
            
            // Button that toggles the sheet view to show category selection:
            Button("Change Category") {
                sheetsViewModel.showNoteCategorySheet.toggle()
                HapticManager.instance.impact(style: .light)
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
    }
}

// MARK: - Extension holding placeholders for untitled notes.
extension NoteEditView {
    /// Strings shown when a note is untitled to invite the user to title it.
    static let untitledNotePlaceholders = [
        "Title your note...",
        "Title your imagination...",
        "Title your inspiration..."
    ]
}
