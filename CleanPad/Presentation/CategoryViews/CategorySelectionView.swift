//
//  CategorySelectionView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 26/02/24.
//

import SwiftUI

/// View that shows all user categories. User can filter notes by selecting one category or tap a button to edit categories.
struct CategorySelectionView: View {
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TopDismissViewButton()
            
            CustomTopTitle(text: viewModel.isEditModeActive ? "Edit your Categories" : "Select a Category")
                .padding(.horizontal)
            
            categoriesGridView
            
            editCategoriesButton
                .padding(.vertical)
        }
        .padding(.top)
        .presentationDragIndicator(.visible)
        .presentationBackground(.thinMaterial)
        .presentationCornerRadius(Constants.roundedRectCornerRadius)
    }
    
    /// Button to show view for Categories Editing.
    var editCategoriesButton: some View {
        Toggle(
            viewModel.isEditModeActive ? "Done Editing" : "Edit Categories",
            systemImage: "pencil",
            isOn: $viewModel.isEditModeActive.animation(.easeInOut(duration: 0.3))
        )
        .toggleStyle(.button)
        .contentTransition(.symbolEffect)
        .onChange(of: viewModel.isEditModeActive) {
            HapticManager.instance.impact(style: .light)
        }
    }
    
    @ViewBuilder
    var bottomSheetButton: some View {
        if viewModel.isEditModeActive {
            CreateCategoryButton(
                viewModel: viewModel,
                sheetsViewModel: sheetsViewModel
            )
        } else {
            CategoryButton(
                viewModel: viewModel,
                sheetsViewModel: sheetsViewModel,
                category: .noSelection,
                role: viewModel.isEditModeActive ? .edition : .selection
            ) {
                // TODO: Refactor and move to VM:
                withAnimation(.bouncy) {
                    viewModel.changeSelectedCategory(with: .noSelection)
                }
                HapticManager.instance.impact(style: .soft)
                
                dismiss()
                viewModel.customTabBarGlow()
            }
        }
    }
    
    var categoriesListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.categories) { category in
                    CategoryButton(
                        viewModel: viewModel,
                        sheetsViewModel: sheetsViewModel,
                        category: category,
                        role: viewModel.isEditModeActive ? .edition : .selection
                    ) {
                        // TODO: Refactor and move to VM:
                        if viewModel.isEditModeActive {
                            viewModel.changeCurrentEditableCategory(with: category)
                            sheetsViewModel.showCategoryEditSheet.toggle()
                        } else {
                            withAnimation(.bouncy) {
                                viewModel.changeSelectedCategory(with: category)
                            }
                            HapticManager.instance.impact(style: .soft)
                            
                            dismiss()
                            viewModel.customTabBarGlow()
                        }
                    }
                    .padding(.vertical, 5)
                }
                .padding(.horizontal)
                
                categoriesBottomView
            }
        }
    }
    
    var categoriesGridView: some View {
        let layout = [
            GridItem(
                .adaptive(minimum: viewModel.idiom == .pad ? 200 : 160)
            )
        ]
        
        return Group {
            ScrollView {
                LazyVGrid(columns: layout) {
                    ForEach(viewModel.categories) { category in
                        CategoryButton(
                            viewModel: viewModel,
                            sheetsViewModel: sheetsViewModel,
                            category: category,
                            role: viewModel.isEditModeActive ? .edition : .selection
                        ) {
                            // TODO: Refactor and move to VM:
                            if viewModel.isEditModeActive {
                                viewModel.changeCurrentEditableCategory(with: category)
                                sheetsViewModel.showCategoryEditSheet.toggle()
                            } else {
                                withAnimation(.bouncy) {
                                    viewModel.changeSelectedCategory(with: category)
                                }
                                HapticManager.instance.impact(style: .soft)
                                
                                dismiss()
                                viewModel.customTabBarGlow()
                            }
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 5)
                    }
                }
                .padding()
                
                categoriesBottomView
            }
        }
    }
    
    var categoriesBottomView: some View {
        Group {
            Divider()
            bottomSheetButton
        }
        .padding()
    }
}

/// View for a Button that adapts according to Category Edition and Selection modes.
struct CategoryButton: View {
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    var category: Category
    var role: CategoryButtonRole
    var buttonActions: () -> Void
    
    var strokeColorGradient: AnyGradient {
        viewModel.selectedCategory == category ? category.color.gradient : Color.gray.gradient
    }
    
    enum CategoryButtonRole {
        case selection
        case edition
    }

    var body: some View {
        Button { buttonActions() } label: {
            HStack {
                Text(category.name.isEmpty ? "Unnamed Category" : category.name)
                    .foregroundStyle(category.name.isEmpty ? .secondary : .primary)
                
                Spacer()
                
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
            .contentTransition(.symbolEffect(.automatic))
        }
        .buttonStyle(
            GradientButtonStyle(
                startColor: .gridLabelBackground.opacity(0.8),
                endColor: category.color.opacity(0.8)
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
    }
    
    var roleDependentOverlay: some View {
        if role == .selection {
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    strokeColorGradient.opacity(
                        viewModel.selectedCategory == category ? 0.5 : 0.1
                    ),
                    lineWidth: 4
                )
        } else {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.gradient.opacity(0.1), lineWidth: 3)
        }
    }
}

struct CreateCategoryButton: View {
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    var body: some View {
        Button {
            sheetsViewModel.showCategoryCreationSheet.toggle()
        } label: {
            HStack {
                Text("Create New Category")
                Spacer()
                Image(systemName: "plus")
                    .bold()
            }
        }
        .buttonStyle(MaterialRoundedButtonStyle())
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.gradient.opacity(0.1), lineWidth: 3)
        }
    }
}

#Preview("CategorySelectionView Sheet") {
    CategorySelectionView(viewModel: NotesListViewModel(), sheetsViewModel: SheetsViewModel())
}
