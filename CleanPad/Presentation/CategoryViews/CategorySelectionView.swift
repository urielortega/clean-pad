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
        .presentationBackground(.ultraThinMaterial)
        .presentationCornerRadius(Constants.roundedRectCornerRadius)
        .presentationDetents([.fraction(0.6)])
    }
    
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
            
            withAnimation(.easeInOut(duration: 0.3)) {
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
//            CategoryButton(
//                viewModel: viewModel,
//                sheetsViewModel: sheetsViewModel,
//                category: .noSelection,
//                role: viewModel.isEditModeActive ? .edition : .selection
//            ) {
//                // TODO: Refactor and move to VM:
//                withAnimation(.bouncy) {
//                    viewModel.changeSelectedCategory(with: .noSelection)
//                }
//                HapticManager.instance.impact(style: .soft)
//                
//                dismiss()
//                viewModel.customTabBarGlow()
//            }
            NoCategoryButton(viewModel: viewModel, sheetsViewModel: sheetsViewModel)
        }
    }
    
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

/// View for a Button that adapts according to Category Edition and Selection modes.
struct CategoryButton: View {
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    var category: Category
    var role: CategoryButtonRole
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
        Button { buttonActions() } label: {
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
        }
        .padding()
        .fontWeight(.medium)
        .background(.thinMaterial)
        .clipShape(.rect(cornerRadius: Constants.materialButtonCornerRadius))
        .largeShadow(color: .gradientButtonShadow)
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


struct CreateCategoryButton: View {
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    var body: some View {
        Button {
            sheetsViewModel.showCategoryCreationSheet.toggle()
        } label: {
            Image(systemName: "plus")
                .padding(5)
        }
        .buttonStyle(MaterialCircleButtonStyle())
        .overlay {
            Circle()
                .stroke(Color.gray.gradient.opacity(0.1), lineWidth: 3)
        }
    }
}

#Preview("CategorySelectionView Sheet") {
    CategorySelectionView(viewModel: NotesListViewModel(), sheetsViewModel: SheetsViewModel())
}
