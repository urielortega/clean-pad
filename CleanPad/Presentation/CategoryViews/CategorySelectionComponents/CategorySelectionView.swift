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
            editAndDismissTopView
            
            CustomTopTitle(text: viewModel.isEditModeActive ? "Edit your Categories" : "Select a Category")
                .padding(.horizontal)
            
            categoriesGridView
        }
        .padding(.top)
        .presentationDragIndicator(.visible)
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(Constants.roundedRectCornerRadius)
        .presentationDetents([.fraction(0.6)])
    }
}

// MARK: - Extension to group secondary views in CategorySelectionView.
extension CategorySelectionView {
    var editAndDismissTopView: some View {
        HStack {
            editCategoriesButton
            Spacer()
            DismissViewButton()
        }
        .padding([.horizontal, .bottom])
    }
    
    /// Button to show view for Categories Editing.
    var editCategoriesButton: some View {
        Button(viewModel.isEditModeActive ? "Done" : "Edit") {
            HapticManager.instance.impact(style: .light)
            
            withAnimation(.bouncy) {
                viewModel.isEditModeActive.toggle()
            }
        }
    }
    
    /// View that shows either CreateCategoryButton or CategoryButton with no selection, depending on the status of Edit Mode.
    @ViewBuilder
    var bottomSheetButton: some View {
        if viewModel.isEditModeActive {
            CreateCategoryButton(
                viewModel: viewModel,
                sheetsViewModel: sheetsViewModel
            )
        } else {
            NoCategoryButton(viewModel: viewModel, sheetsViewModel: sheetsViewModel)
        }
    }
}

// MARK: - Extension to group the two different types of views for CategorySelectionView.
extension CategorySelectionView {
    /// View that shows categories as rows in a single column.
    var categoriesListView: some View {
        ZStack {
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
                }
                .padding(.bottom, 80) // To avoid hiding the list behind the bottomSheetButton.
            }
            
            VStack {
                Spacer()
                bottomSheetButton
                    .padding()
            }
        }
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
                        CategoryButton(
                            viewModel: viewModel,
                            sheetsViewModel: sheetsViewModel,
                            category: category,
                            role: viewModel.isEditModeActive ? .edition : .selection,
                            isButtonDisabled: viewModel.isEditModeActive && (category.id == Category.general.id) // Disable General Category Button when Edit Mode is active.
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
                .padding(.bottom, 80) // To avoid hiding the list behind the bottomSheetButton.
            }
            
            VStack {
                Spacer()
                bottomSheetButton
                    .padding()
            }
        }
    }
}

#Preview("CategorySelectionView Sheet") {
    CategorySelectionView(viewModel: NotesListViewModel(), sheetsViewModel: SheetsViewModel())
}