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
    @State var isEditModeActive = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack { // View to place Dismiss Button at the top of the sheet.
                Spacer()
                DismissViewButton()
            }
            
            HStack { // View to place title at the top of the sheet.
                Text("Your Categories")
                    .font(.title)
                    .bold()
                
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.categories) { category in
                        if isEditModeActive {
                            Button("Editable Category Button") { sheetsViewModel.showCategoryEditViewSheet.toggle() }
                        } else {
                            SelectableCategoryButton(
                                category: category,
                                viewModel: viewModel,
                                sheetsViewModel: sheetsViewModel
                            )
                        }
                    }
                    
                    if !isEditModeActive {
                        Divider()
                            .padding(.vertical)
                        
                        SelectableCategoryButton(
                            category: .noSelection,
                            viewModel: viewModel,
                            sheetsViewModel: sheetsViewModel
                        )
                    }
                }
                .padding()
            }
            
            editCategoriesButton
                .padding(.vertical)
                .padding(.bottom)
        }
        .padding(.top)
        .presentationDetents([.fraction(0.5), .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(roundedRectCornerRadius)
    }
    
    /// Button to show view for Categories Editing.
    var editCategoriesButton: some View {
        Button("Edit", systemImage: "pencil") {
            withAnimation(.bouncy) {
                isEditModeActive.toggle()
                HapticManager.instance.impact(style: .light)
            }
        }
    }
}

/// A selectable View that shows a category name and color.
struct SelectableCategoryButton: View {
    var category: Category
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    @Environment(\.dismiss) var dismiss
        
    var strokeColorGradient: AnyGradient {
        viewModel.selectedCategory == category ? category.color.gradient : Color.gray.gradient
    }
    
    var body: some View {
        HStack {
            Label("\(category.name)", systemImage: "note.text")
                .imageScale(.medium)
                .foregroundStyle(category.color.gradient)
            
            Spacer()
            
            if viewModel.selectedCategory == category {
                Image(systemName: "checkmark")
                    .foregroundStyle(category.color)
                    .bold()
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    strokeColorGradient.opacity(
                        viewModel.selectedCategory == category ? 0.5 : 0.1
                    ),
                    lineWidth: 3
                )
        }
        .shadow(color: .gridLabelShadow, radius: 2, x: 0, y: 6)
        .onTapGesture {
            withAnimation(.bouncy) { viewModel.changeSelectedCategory(with: category) }
            
            HapticManager.instance.impact(style: .soft)
            dismiss()
            
            // CustomTabBar Glow:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 1)) {
                    viewModel.isCustomTabBarGlowing.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 1)) {
                        viewModel.isCustomTabBarGlowing.toggle()
                    }
                }
            }
        }
    }
}


enum CategoryButtonRole {
    case selection
    case edition
}

/// View to be used as label for buttons that adapt for Category Edition and Selection modes.
struct CategoryButtonLabel: View {
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    @Environment(\.dismiss) var dismiss
    
    var category: Category
    var role: CategoryButtonRole
    var buttonActions: () -> Void
    
    var strokeColorGradient: AnyGradient {
        viewModel.selectedCategory == category ? category.color.gradient : Color.gray.gradient
    }
    
    var body: some View {
        HStack {
            Label("\(category.name)", systemImage: "note.text")
                .imageScale(.medium)
                .foregroundStyle(category.color.gradient)
            
            Spacer()
            
            Group {
                if (viewModel.selectedCategory == category && role == .selection) {
                    Image(systemName: "checkmark")
                        .foregroundStyle(category.color)
                        .bold()
                } else if role == .edition {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(category.color)
                        .bold()
                }
            }
            .contentTransition(.symbolEffect(.replace))
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 10))
        .overlay {
            if role == .selection {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        strokeColorGradient.opacity(
                            viewModel.selectedCategory == category ? 0.5 : 0.1
                        ),
                        lineWidth: 3
                    )
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.gradient.opacity(0.1), lineWidth: 3)
            }
        }
        .shadow(color: .gridLabelShadow, radius: 2, x: 0, y: 6)
        .onTapGesture {
            buttonActions()
        }
    }
}

#Preview("CategorySelectionView Sheet") {
    CategorySelectionView(viewModel: NotesListViewModel(), sheetsViewModel: SheetsViewModel())
}

#Preview("CategoryFilteringLabel") {
    SelectableCategoryButton(category: .example, viewModel: NotesListViewModel(), sheetsViewModel: SheetsViewModel())
        .padding()
}
