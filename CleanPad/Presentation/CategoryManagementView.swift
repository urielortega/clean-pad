//
//  CategoryManagementView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 26/02/24.
//

import SwiftUI

struct CategoryManagementView: View {
    @ObservedObject var viewModel: NotesListViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text("Your Categories")
                    .font(.title)
                    .bold()
                
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVStack {
                    CategoryFilteringLabel(category: .example, viewModel: viewModel)
                    CategoryFilteringLabel(category: .general, viewModel: viewModel)
                    CategoryFilteringLabel(category: .emptySelection, viewModel: viewModel)
                }
                .padding()
            }
        }
        .padding(.top)
        .presentationDetents([.fraction(0.4), .medium])
        .presentationDragIndicator(.visible)
        .presentationBackground(.ultraThinMaterial)
    }
}

struct CategoryFilteringLabel: View {
    var category: Category
    @ObservedObject var viewModel: NotesListViewModel
    @Environment(\.dismiss) var dismiss
    
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
        .shadow(color: .gridLabelShadow, radius: 2, x: 0, y: 6)
        .onTapGesture {
            withAnimation(.bouncy) {
                viewModel.selectedCategory = category
            }
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

#Preview("CategoryManagementView Sheet") {
    CategoryManagementView(viewModel: NotesListViewModel())
}

#Preview("CategoryFilteringLabel") {
    CategoryFilteringLabel(category: .example, viewModel: NotesListViewModel())
        .padding()
}
