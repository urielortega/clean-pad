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
    @Binding var showEditableCategoriesSheet: Bool
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                DismissViewButton()
            }
            
            HStack {
                Text("Your Categories")
                    .font(.title)
                    .bold()
                
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.categories) { category in
                        CategoryFilteringLabel(
                            category: category,
                            viewModel: viewModel
                        )
                    }
                    
                    Divider()
                        .padding(.vertical)
                    
                    CategoryFilteringLabel(category: .noSelection, viewModel: viewModel)
                }
                .padding()
            }
            
            EditCategoriesButton(showEditableCategoriesSheet: $showEditableCategoriesSheet)
                .padding(.vertical)
                .padding(.bottom)
        }
        .padding(.top)
        .presentationDetents([.fraction(0.5), .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(roundedRectCornerRadius)
    }
}

/// A selectable View that shows a category name and color.
struct CategoryFilteringLabel: View {
    var category: Category
    @ObservedObject var viewModel: NotesListViewModel
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

/// Button to show view for Categories Editing.
struct EditCategoriesButton: View {
    @Binding var showEditableCategoriesSheet: Bool

    var body: some View {
        Button("Edit", systemImage: "pencil") {
            showEditableCategoriesSheet.toggle()
            HapticManager.instance.impact(style: .light)
        }
    }
}

#Preview("CategorySelectionView Sheet") {
    CategorySelectionView(viewModel: NotesListViewModel(), showEditableCategoriesSheet: .constant(false))
}

#Preview("CategoryFilteringLabel") {
    CategoryFilteringLabel(category: .example, viewModel: NotesListViewModel())
        .padding()
}
