//
//  LabelViews.swift
//  CleanPad
//
//  Created by Uriel Ortega on 30/10/23.
//

import SwiftUI

/// View that shows a note title, date, category and some content when user selects List View in AlINotesView.
struct ListNoteLabel: View {
    var note: Note
    @ObservedObject var viewModel: DateViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                NoteCategoryIndicator(note: note)

                Text(note.noteTitle.isEmpty ? "Untitled" : note.noteTitle)
                    .lineLimit(1)
                    .foregroundStyle(note.noteTitle.isEmpty ? .secondary : .primary)
                    .fontWeight(.medium)
            }

            VStack(alignment: .leading) {
                FormattedDateTextView(note: note, viewModel: viewModel)
                
                Text(note.noteContent.isEmpty ? "No content..." : note.noteContent)
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
            }
            .font(.caption2)

        }
        .noteLabelAccessibilityModifiers(note: note, viewModel: viewModel)
    }
}

/// View that shows a note title, date, category and some content when user selects Grid View in AlINotesView.
struct GridNoteLabel: View {
    var note: Note
    @ObservedObject var viewModel: DateViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.noteTitle.isEmpty ? "Untitled" : note.noteTitle)
                .lineLimit(1)
                .foregroundStyle(note.noteTitle.isEmpty ? .secondary : .primary)
                .fontWeight(.medium)

            VStack(alignment: .leading) {
                FormattedDateTextView(note: note, viewModel: viewModel)
                
                Text(note.noteContent.isEmpty ? "No content..." : note.noteContent)
                    .lineLimit(2, reservesSpace: true)
                    .foregroundStyle(.secondary)
                    .foregroundStyle(note.noteContent.isEmpty ? .secondary : .primary)
                    .multilineTextAlignment(.leading)
            }
            .font(.caption2)
            
            Divider()
                .padding(.vertical, 2)
            
            HStack(alignment: .center) {
                NoteCategoryIndicator(note: note)
                Text(note.category?.displayName ?? "No Category Selected")
                    .font(.caption2)
                    .bold(note.category == nil ? false : true)
                    .foregroundStyle(note.category == nil ? .gray : Color(.label))
                    .lineLimit(1)
            }
        }
        .foregroundStyle(Color(.label)) // To show an appropriate color in both light and dark mode.
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding()
        .background(.gridLabelBackground)
        .clipShape(.rect(cornerRadius: Constants.roundedRectCornerRadius))
        .roundedRectangleOverlayStroke()
        .softShadow(color: .gridLabelShadow)
        .noteLabelAccessibilityModifiers(note: note, viewModel: viewModel)
    }
}

/// View that shows the preview of a note, including title and content. Meant to be displayed as a Context Menu Preview.
struct ContextMenuPreview: View {
    var note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.noteTitle.isEmpty ? "Untitled" : note.noteTitle)
                .lineLimit(2)
                .foregroundStyle(note.noteTitle.isEmpty ? .secondary : .primary)
                .multilineTextAlignment(.leading)
                .bold()
            
            Divider()
            
            Text(note.noteContent.isEmpty ? "No content..." : note.noteContent)
                .lineLimit(7)
                .foregroundStyle(note.noteContent.isEmpty ? .secondary : .primary)
                .multilineTextAlignment(.leading)
                .font(.caption)
            
            Spacer()
        }
        .frame(width: 300, height: 150)
        .padding()
    }
}

/// Text View that shows the formatted date of a note, displaying the abbreviated date (when note's date is different than today) and shortened time.
fileprivate struct FormattedDateTextView: View {
    var note: Note
    @ObservedObject var viewModel: DateViewModel
    
    var body: some View {
        Text(
            note.date.formatted(
                // Shows abbreviated date only when note.date is different from today:
                date: viewModel.isNoteDateEqualToToday(note: note) ? .omitted : .abbreviated,
                time: .shortened
            )
        )
        .lineLimit(1)
        .foregroundStyle(.primary)
        .padding(.bottom, 1)

    }
}


#if DEBUG
#Preview("List View") {
    ListNoteLabel(note: .example, viewModel: DateViewModel())
        .padding()
        .border(.gray, width: 0.5)
}

#Preview("Grid View") {
    GridNoteLabel(note: .example, viewModel: DateViewModel())
        .frame(width: 200, height: 100)
}

#Preview("Context Menu Preview") {
    ContextMenuPreview(note: .example)
        .border(.gray, width: 0.5)
}
#endif
