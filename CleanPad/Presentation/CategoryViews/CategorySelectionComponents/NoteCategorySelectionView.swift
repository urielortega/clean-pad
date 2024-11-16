//
//  NoteCategorySelectionView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 27/08/24.
//

import AlertKit
import Foundation
import SwiftUI

/// View that shows all user categories. User can assign a category to a note by tapping one.
struct NoteCategorySelectionView: View {
    @Binding var note: Note
    @Binding var creatingNewNote: Bool

    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var triggerHapticFeedback: Bool = false
    
    /// Property that determines whether an `AlertAppleMusic17View` is displayed to inform the user that a category has been successfully created and assigned to the current note.
    @State var isAlertPresented: Bool = false
    
    /// An `AlertAppleMusic17View` instance configured to display a success message when a category is created and assigned to the current note.
    let alertView = AlertAppleMusic17View(title: "Category created!", subtitle: "And assigned to your note", icon: .done)
    
    var body: some View {
        VStack {
            dismissTopView
            
            CustomTopTitle(text: "Change Note Category")
                .padding(.horizontal)
            
            categoriesGridView
        }
        .padding(.top)
        .presentationDragIndicator(.visible)
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(Constants.roundedRectCornerRadius)
        .presentationDetents([.fraction(0.6)])
        .alert(isPresent: $isAlertPresented, view: alertView)
    }
}

// MARK: - Extension to group secondary views in NoteCategorySelectionView.
extension NoteCategorySelectionView {
    var dismissTopView: some View {
        HStack {
            Spacer()
            DismissViewButton()
        }
        .padding([.horizontal, .bottom])
    }
    
    /// View that shows categories as a grid with multiple columns.
    var categoriesGridView: some View {
        let layout = [
            GridItem(
                .adaptive(minimum: viewModel.idiom == .pad ? 200 : 160)
            )
        ]
        
        return ZStack {
            ScrollView {
                LazyVGrid(columns: layout) {
                    ForEach(viewModel.categories) { category in
                        NoteCategoryButton(
                            note: $note,
                            category: category,
                            creatingNewNote: $creatingNewNote,
                            triggerHapticFeedback: $triggerHapticFeedback,
                            viewModel: viewModel
                        )
                        .padding(5)
                    }
                }
                .padding()
                .padding(.bottom, 100) // To avoid hiding the list behind the CreateAndAssignNoteCategoryButton.
            }
            .overlay(alignment: .bottom) {
                VariableBlurView(
                    maxBlurRadius: 6,
                    direction: .blurredBottomClearTop
                )
                .ignoresSafeArea()
                .frame(height: 120)
                .allowsHitTesting(true)
            }
            
            VStack {
                Spacer()
                CreateAndAssignNoteCategoryButton(
                    viewModel: viewModel,
                    sheetsViewModel: sheetsViewModel,
                    note: $note,
                    isAlertPresented: $isAlertPresented
                )
                .padding()
            }
        }
    }
}
