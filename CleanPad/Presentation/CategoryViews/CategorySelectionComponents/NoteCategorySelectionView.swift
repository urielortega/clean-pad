//
//  NoteCategorySelectionView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 27/08/24.
//

import Foundation
import SwiftUI

struct NoteCategorySelectionView: View {
    @Binding var note: Note

    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            dismissTopView
            
            CustomTopTitle(text: "Assign a Category")
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

// MARK: - Extension to group secondary views in NoteCategorySelectionView.
extension NoteCategorySelectionView {
    var dismissTopView: some View {
        HStack {
            Spacer()
            DismissViewButton()
        }
        .padding([.horizontal, .bottom])
    }
    
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
                            viewModel: viewModel
                        )
                    }
                }
                .padding()
            }
        }
    }
}
