//
//  CategorySelectionButtons.swift
//  CleanPad
//
//  Created by Uriel Ortega on 27/08/24.
//

import Foundation
import SwiftUI

extension CategorySelectionView {
    /// Button that adapts according to Category Edition and Selection modes.
    struct CategoryButton: View {
        @ObservedObject var viewModel: NotesListViewModel
        @ObservedObject var sheetsViewModel: SheetsViewModel
        
        var category: Category
        var role: CategoryButtonRole
        var isButtonDisabled: Bool = false
        var gradientStartColorOpacity = Constants.gradientStartColorOpacity
        var gradientEndColorOpacity = Constants.gradientEndColorOpacity
        var buttonActions: () -> Void
        
        var strokeColorGradient: AnyGradient {
            viewModel.selectedCategory == category ? category.color.gradient : Color.gray.gradient
        }
        
        enum CategoryButtonRole {
            case selection
            case edition
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
                CategoryEditView(
                    category: viewModel.currentEditableCategory,
                    viewModel: viewModel,
                    creatingNewCategory: false
                )
            }
            .sheet(isPresented: $sheetsViewModel.showCategoryCreationSheet) { // Category Creation sheet must be at the same level as Category Edit sheet.
                CategoryEditView(
                    category: Category(id: UUID(), name: "", color: .gray),
                    viewModel: viewModel,
                    creatingNewCategory: true
                )
            }
            .opacity(isButtonDisabled ? 0.3 : 1.0)
        }
        
        /// View that dynamically displays either a gray or a colorful stroke based on the current mode (Selection Mode or Edit Mode) and the category that is currently selected.
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
        
        /// View that dynamically displays either a "Radio Button" or a "Disclosure Indicator" based on the current mode (Selection Mode or Edit Mode).
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
    
    /// Button for changing the selected Category to noSelection.
    struct NoCategoryButton: View {
        @ObservedObject var viewModel: NotesListViewModel
        @ObservedObject var sheetsViewModel: SheetsViewModel
        
        @Environment(\.dismiss) var dismiss
        
        var strokeColorGradient: AnyGradient {
            viewModel.selectedCategory == Category.noSelection ? Color(.label).gradient : Color.gray.gradient
        }
        
        var body: some View {
            Button {
                // TODO: Refactor and move to VM:
                withAnimation(.bouncy) {
                    viewModel.changeSelectedCategory(with: .noSelection)
                }
                HapticManager.instance.impact(style: .soft)
                
                dismiss()
                viewModel.customTabBarGlow()
            } label: {
                Text("All notes")
                    .foregroundStyle(Color(.label).gradient)
                    .frame(width: 100, height: 16) // Frame on Label so tap is better detected.
            }
            .padding()
            .fontWeight(.medium)
            .background(.thinMaterial)
            .clipShape(.rect(cornerRadius: Constants.materialButtonCornerRadius))
            .largeShadow(color: .black.opacity(0.3))
            .overlay { adaptableOverlay }
        }
        
        /// View that adapts the stroke if the category is currently selected.
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
    
    /// Button for creating a new Category by toggling the showCategoryCreationSheet property.
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
        }
    }
}

extension NoteCategorySelectionView {
    /// Button for assigning a Category to a Note.
    struct NoteCategoryButton: View {
        @Binding var note: Note
        var category: Category
        @Binding var creatingNewNote: Bool
        
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
            .overlay { adaptableOverlay }
        }
        
        /// View that visually differentiates the note category from the rest of the user's categories.
        var dynamicIndicator: some View {
            Image(
                systemName: (note.category?.id == category.id) ? "circle.fill" : "circle"
            )
            .foregroundStyle(category.color)
            .bold()
            .subtleShadow(color: .black.opacity(0.2))
        }
        
        /// View that adapts the stroke if the category is currently selected.
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
    
    /// Button for creating a new Category and assign it to a Note.
    struct CreateAndAssignNoteCategoryButton: View {
        @ObservedObject var viewModel: NotesListViewModel
        @ObservedObject var sheetsViewModel: SheetsViewModel
        
        @Binding var note: Note
        @State private var category = Category(id: UUID(), name: "", color: .gray)
        
        @State private var showingAlert = false
        @State private var categoryName: String = ""
        
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
                    Button("Save") {
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
                    \nYou can further personalize it by tapping the Category Selection button in your Home Tab Bar.
                    """
                )
            }
        }
        
        /// Function to create a new category and assign it to the current note.
        func createAndAssignCategory() {
            // TODO: Create a new category. Assign it to the current note.
            print("Your Category: \(categoryName). Your note: \(note.noteTitle)")
            HapticManager.instance.notification(type: .success)
        }
    }
}
