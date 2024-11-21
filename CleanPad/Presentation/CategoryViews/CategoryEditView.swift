//
//  CategoryEditView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 18/03/24.
//

import AlertKit
import SwiftUI

/// Enum for controlling the focus state when creating or editing a category.
fileprivate enum FocusField: Hashable {
    case categoryNameTextField
}

/// View that shows all user categories that can be edited by tapping one of them.
struct CategoryEditView: View {
    @State var category: Category
    @State private var showingConfirmation = false
    
    @ObservedObject var viewModel: NotesListViewModel
    
    /// Property to show Cancel and Save buttons, and handle `onChange` closures.
    var creatingNewCategory: Bool
    
    /// Property that determines whether an `AlertAppleMusic17View` is displayed to inform the user that a category has been successfully created.
    @State var isAlertPresented: Bool = false
    
    /// An `AlertAppleMusic17View` instance configured to display a success message when a category is created.
    let alertView = AlertAppleMusic17View(title: "Category created!", subtitle: nil, icon: .done)
    
    /// Property that stores the focus of the current text field.
    @FocusState private var focusedField: FocusField?
    
    @Environment(\.dismiss) var dismiss
    
    /// Property to adapt the UI for VoiceOver users.
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
        
    var body: some View {
        NavigationStack {
            VStack {
                CustomTopTitle(
                    text: creatingNewCategory ? "Create New Category" : "Edit Category"
                )
                .padding([.horizontal, .top])
                
                HStack {
                    categoryNameTextField
                    
                    categoryColorPicker
                        .padding(.leading)
                }
                .padding()
                .padding(.trailing)
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if !(focusedField == .none) {
                        // Button to dismiss keyboard when typing.
                        Button("OK") { focusedField = .none }
                    } else {
                        HStack {
                            if !creatingNewCategory {
                                Button("Delete Category", systemImage: "trash", role: .destructive) {
                                    showingConfirmation = true
                                }
                            }
                            
                            saveCategoryButtonView
                        }
                    }
                }
            }
        }
        .presentationBackground(
            LinearGradient(
                gradient: Gradient(
                    stops: [
                        .init(color: .generalBackground, location: 0.2),
                        .init(color: category.color, location: 1.5)
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .presentationCornerRadius(Constants.roundedRectCornerRadius)
        .onAppear {
            if creatingNewCategory { focusedField = .categoryNameTextField }
        }
        .confirmationDialog("Confirm Category Deletion", isPresented: $showingConfirmation) {
            DeleteCategoryButton(
                category: category,
                viewModel: viewModel,
                dismissView: true
            )
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("""
                Are you sure you want to delete this category?
                All notes in the "\(category.displayName)" category will be moved to the General category.
            """)
        }
        .alert(isPresent: $isAlertPresented, view: alertView)
    }
    
    var categoryNameTextField: some View {
        TextField( "Name your category...", text: $category.name)
            .textFieldStyle(
                GradientTextFieldStyle(
                    startColor: .gridLabelBackground.opacity(0.8),
                    endColor: category.color.opacity(0.8)
                )
            )
            .focused($focusedField, equals: .categoryNameTextField)
    }
    
    var categoryColorPicker: some View {
        ColorPicker(
            "Set the category color",
            selection: $category.color,
            supportsOpacity: false
        )
        .labelsHidden()
    }
    
    var saveCategoryButtonView: some View {
        Button("Save") {
            if creatingNewCategory {
                viewModel.add(category: category)
                isAlertPresented.toggle() // Alert is only presented when creating a new category.
            } else {
                viewModel.update(category: category)
            }
            
            dismiss()
            
            HapticManager.instance.notification(type: .success)
        }
    }
}

#if DEBUG
#Preview {
    CategoryEditView(
        category: .thoughts,
        viewModel: NotesListViewModel(),
        creatingNewCategory: false
    )
}
#endif
