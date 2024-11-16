//
//  CategorySelectionButtons.swift
//  CleanPad
//
//  Created by Uriel Ortega on 27/08/24.
//

import Foundation
import SwiftUI

extension CategorySelectionView {
    /// Button that adapts its appearance and behavior based on the specified role (Selection or Edition).
    struct CategoryButton: View {
        @ObservedObject var viewModel: NotesListViewModel
        @ObservedObject var sheetsViewModel: SheetsViewModel
        
        var category: Category
        var role: CategoryButtonRole // Determines whether this button is used for category selection or editing
        var isButtonDisabled: Bool = false
        var gradientStartColorOpacity = Constants.gradientStartColorOpacity
        var gradientEndColorOpacity = Constants.gradientEndColorOpacity
        var buttonActions: () -> Void // Actions to execute when button is tapped

        /// Gradient for the button's stroke, changes based on selection state.
        var strokeColorGradient: AnyGradient {
            viewModel.selectedCategory == category ? category.color.gradient : Color.gray.gradient
        }
        
        enum CategoryButtonRole {
            case selection // Button used for selecting a category
            case edition   // Button used for editing a category
        }
        
        var body: some View {
            Button {
                isButtonDisabled ? HapticManager.instance.notification(type: .error) : buttonActions()
            } label: {
                HStack {
                    Text(category.displayName)
                        .foregroundStyle(category.name.isEmpty ? .secondary : .primary)
                        .lineLimit(role == .selection ? 1 : 2)
                    
                    Spacer()
                    
                    dynamicIndicator
                }
                .contentTransition(.symbolEffect(.automatic))
            }
            .buttonStyle(
                GradientButtonStyle(
                    startColor: .gridLabelBackground,
                    endColor: category.color,
                    startColorOpacity: gradientStartColorOpacity,
                    endColorOpacity: gradientEndColorOpacity
                )
            )
            .overlay { roleDependentOverlay }
            .sheet(isPresented: $sheetsViewModel.showCategoryEditSheet) {
                // Presents the Category Edit sheet if `showCategoryEditSheet` is true.
                CategoryEditView(
                    category: viewModel.currentEditableCategory,
                    viewModel: viewModel,
                    creatingNewCategory: false
                )
            }
            .sheet(isPresented: $sheetsViewModel.showCategoryCreationSheet) { // Category Creation sheet must be at the same level as Category Edit sheet.
                // Presents the Category Creation sheet if `showCategoryCreationSheet` is true.
                CategoryEditView(
                    category: Category(id: UUID(), name: "", color: .gray),
                    viewModel: viewModel,
                    creatingNewCategory: true
                )
            }
            .opacity(isButtonDisabled ? 0.3 : 1.0)
            .accessibilityElement()
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("\(category.displayName) Category")
        }
        
        /// A rounded rectangle overlay with a stroke, adapting to selection or edition mode.
        var roleDependentOverlay: some View {
            if role == .selection {
                RoundedRectangle(cornerRadius: Constants.materialButtonCornerRadius)
                    .stroke(
                        strokeColorGradient.opacity(
                            viewModel.selectedCategory == category ? 0.5 : 0.1
                        ),
                        lineWidth: 4
                    )
            } else {
                RoundedRectangle(cornerRadius: Constants.materialButtonCornerRadius)
                    .stroke(Color.gray.gradient.opacity(0.1), lineWidth: 3)
            }
        }
        
        /// Displays a dynamic indicator (radio button or disclosure indicator) based on the button's role.
        var dynamicIndicator: some View {
            Image(
                systemName:
                    // In Selection Mode, when the category is selected, show a "circle.fill" image.
                (role == .selection && viewModel.selectedCategory == category) ? "circle.fill" :
                    // In Edition Mode...
                // ...show a "chevron.right" image.
                // Otherwise, show a "circle" image, i.e. in Selection Mode, when the category is not selected.
                (role == .edition ? "chevron.right" : "circle")
            )
            .foregroundStyle(category.color)
            .bold()
            .subtleShadow(color: .black.opacity(0.2))
        }
    }
    
    /// Button for selecting "All notes" (no category).
    struct NoCategoryButton: View {
        @ObservedObject var viewModel: NotesListViewModel
        @ObservedObject var sheetsViewModel: SheetsViewModel
        
        @Environment(\.dismiss) var dismiss
        
        /// Gradient used for the stroke, based on selection state.
        var strokeColorGradient: AnyGradient {
            viewModel.selectedCategory == Category.noSelection ? Color(.label).gradient : Color.gray.gradient
        }
        
        var body: some View {
            Button {
                withAnimation(.bouncy) {
                    viewModel.changeSelectedCategory(with: .noSelection)
                }
                HapticManager.instance.impact(style: .soft)
                
                dismiss()
                viewModel.dockGlow()
            } label: {
                Text("All notes")
                    .foregroundStyle(Color(.label).gradient)
                    .frame(width: 100, height: 16) // Frame on Label to improve tap area.
            }
            .padding()
            .fontWeight(.medium)
            .background(.thinMaterial)
            .clipShape(.rect(cornerRadius: Constants.materialButtonCornerRadius))
            .largeShadow(color: .black.opacity(0.3))
            .overlay { adaptableOverlay }
            .accessibilityElement()
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Show all notes")
        }
        
        /// Stroke overlay that adapts if the "All notes" category is selected.
        var adaptableOverlay: some View {
            RoundedRectangle(cornerRadius: Constants.materialButtonCornerRadius)
                .stroke(
                    strokeColorGradient.opacity(
                        viewModel.selectedCategory == Category.noSelection ? 0.4 : 0.1
                    ),
                    lineWidth: 4
                )
        }
    }
    
    /// Button for toggling the display of the Category Creation sheet.
    struct CreateCategoryButton: View {
        @ObservedObject var viewModel: NotesListViewModel
        @ObservedObject var sheetsViewModel: SheetsViewModel
        
        var body: some View {
            Button {
                sheetsViewModel.showCategoryCreationSheet.toggle()
                HapticManager.instance.impact(style: .light)
            } label: {
                Image(systemName: "plus")
                    .bold()
                    .foregroundStyle(.accent.gradient)
                    .padding(5)
            }
            .buttonStyle(MaterialCircleButtonStyle())
            .overlay {
                Circle()
                    .stroke(Color.gray.gradient.opacity(0.1), lineWidth: 4)
            }
            .accessibilityElement()
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Create a Category")
        }
    }
}

extension NoteCategorySelectionView {
    /// Button for assigning a specific Category to a Note.
    struct NoteCategoryButton: View {
        @Binding var note: Note
        var category: Category
        
        @Binding var creatingNewNote: Bool
        @Binding var triggerHapticFeedback: Bool
        
        @ObservedObject var viewModel: NotesListViewModel
        @Environment(\.dismiss) var dismiss
        
        var gradientStartColorOpacity = Constants.gradientStartColorOpacity
        var gradientEndColorOpacity = Constants.gradientEndColorOpacity
        
        var strokeColorGradient: AnyGradient {
            (note.category?.id == category.id) ? category.color.gradient : Color.gray.gradient
        }
        
        var body: some View {
            Button {
                note.category = category
                // When changing an existing note, save its category using update().
                if !creatingNewNote { viewModel.update(note: note, updatingDate: false) }
                HapticManager.instance.impact(style: .soft)
                dismiss()
            } label: {
                HStack {
                    Text(category.displayName)
                        .foregroundStyle(category.name.isEmpty ? .secondary : .primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    dynamicIndicator
                }
                .contentShape(Rectangle()) // Makes the entire HStack area tappable.
                .contentTransition(.symbolEffect(.automatic))
                .onLongPressGesture(perform: { triggerHapticFeedback.toggle() } ) // Haptic Feedback to inform the user that Category Edition is disabled in this View.
            }
            .buttonStyle(
                GradientButtonStyle(
                    startColor: .gridLabelBackground,
                    endColor: category.color,
                    startColorOpacity: gradientStartColorOpacity,
                    endColorOpacity: gradientEndColorOpacity
                )
            )
            .overlay { adaptableOverlay }
            .sensoryFeedback(.error, trigger: triggerHapticFeedback)
            .accessibilityElement()
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("\(category.displayName) Category")
        }
        
        /// Indicator that visually differentiates the current category selection.
        var dynamicIndicator: some View {
            Image(
                systemName: (note.category?.id == category.id) ? "circle.fill" : "circle"
            )
            .foregroundStyle(category.color)
            .bold()
            .subtleShadow(color: .black.opacity(0.2))
        }
        
        /// Overlay stroke that adapts based on the current category selection.
        var adaptableOverlay: some View {
            RoundedRectangle(cornerRadius: Constants.materialButtonCornerRadius)
                .stroke(
                    strokeColorGradient.opacity(
                        (note.category?.id == category.id) ? 0.5 : 0.1
                    ),
                    lineWidth: 4
                )
        }
    }
    
    /// Button for creating a new Category and assigning it to a Note.
    struct CreateAndAssignNoteCategoryButton: View {
        @ObservedObject var viewModel: NotesListViewModel
        @ObservedObject var sheetsViewModel: SheetsViewModel
        
        @Binding var note: Note
        @State private var category: Category?
        
        @State private var showingAlert = false
        @State private var categoryName: String = ""
        
        /// A binding to a Boolean value that determines whether the `AlertAppleMusic17View` is presented.
        /// This property allows the parent view to control the visibility of the alert.
        @Binding var isAlertPresented: Bool
        
        @Environment(\.dismiss) var dismiss
        
        var body: some View {
            Button {
                HapticManager.instance.impact(style: .soft)
                
                showingAlert.toggle()
            } label: {
                Text("Create and assign new category")
                    .foregroundStyle(Color(.label).gradient)
                    .frame(minWidth: 200, maxHeight: 16) // Frame on Label so tap is better detected.
            }
            .padding()
            .fontWeight(.medium)
            .background(.thinMaterial)
            .clipShape(.rect(cornerRadius: Constants.materialButtonCornerRadius))
            .largeShadow(color: .black.opacity(0.3))
            .overlay {
                RoundedRectangle(cornerRadius: Constants.materialButtonCornerRadius)
                    .stroke(Color.gray.gradient.opacity(0.1), lineWidth: 4)
            }
            .alert("Create a new category", isPresented: $showingAlert) {
                Group {
                    TextField("Enter your category name", text: $categoryName)
                    Button("Save and Assign") {
                        createAndAssignCategory()
                        categoryName = "" // Clear the category name.
                    }
                    Button("Cancel", role: .cancel) { }
                }
                .tint(.accent)
            } message: {
                Text(
                    """
                    Your category will be created and assigned to your note.
                    \nYou can further personalize it by tapping the Category Selection button in your Dock.
                    """
                )
            }
            .accessibilityElement()
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Create a new category and assign it to this note.")
        }
        
        /// Creates a new category and assigns it to the current note.
        func createAndAssignCategory() {
            withAnimation {
                // Create a new category with the specified name and default color.
                category = Category(id: UUID(), name: categoryName, color: .gray)
                // Add the category to the view model's list, providing a default if needed.
                viewModel.add(
                    category: category ?? Category(id: UUID(), name: "Unnamed Category", color: .gray)
                )
                
                // Assign the newly created category to the current note.
                note.category = viewModel.categories[
                    viewModel.getCategoryIndexFromCategoriesArray(category: category!)!
                ]
            }
            
            HapticManager.instance.notification(type: .success)
            isAlertPresented.toggle()
        }
    }
}
