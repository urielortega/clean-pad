//
//  LabelViews.swift
//  CleanPad
//
//  Created by Uriel Ortega on 30/10/23.
//

import SwiftUI

struct ListNoteLabel: View {
    var note: Note
    @ObservedObject var viewModel: NotesListViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title.isEmpty ? "New note" : note.title)
            HStack {
                Text(
                    note.date.formatted(
                        // Shows abbreviated date only when note.date is different from today:
                        date: viewModel.isNoteDateEqualToToday(note: note) ? .omitted : .abbreviated,
                        time: .shortened
                    )
                )
                .foregroundStyle(.secondary)
                
                CustomHStackDivider(width: 0.5, height: 14)
                
                Text(note.textContent.isEmpty ? "No content..." : note.textContent)
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
            }
            .font(.caption2)
        }
    }
}

struct GridNoteLabel: View {
    var note: Note
    @ObservedObject var viewModel: NotesListViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title.isEmpty ? "New note" : note.title)
            VStack(alignment: .leading) {
                Text(
                    note.date.formatted(
                        // Shows abbreviated date when note.date is different from today:
                        date: viewModel.isNoteDateEqualToToday(note: note) ? .omitted : .abbreviated,
                        time: .shortened
                    )
                )
                .padding(.bottom, 1)
                
                Text(note.textContent.isEmpty ? "No content..." : note.textContent)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            .font(.caption2)
            
            Spacer()
        }
        .foregroundStyle(Color(.label)) // To show an appropriate color in both light and dark mode.
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray.opacity(0.3), lineWidth: 2)
        )
    }
}


#Preview("List View") {
    ListNoteLabel(note: .example, viewModel: NotesListViewModel())
        .border(.white, width: 0.5)
}

#Preview("Grid View") {
    GridNoteLabel(note: .example, viewModel: NotesListViewModel())
}
