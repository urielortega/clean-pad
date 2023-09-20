//
//  EmptyListView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 20/09/23.
//

import SwiftUI

struct EmptyListView: View {
    // Using the viewModel in a different view with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    @Binding var showEditViewSheet: Bool
    
    var body: some View {
        Button {
            showEditViewSheet.toggle()
        } label: {
            VStack {
                HStack {
                    Text(viewModel.placeholders.randomElement() ?? "Start writing...")
                        .font(.system(size: 60))
                        .fontWeight(.black)
                        .fontDesign(.serif).italic()
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Spacer()
                }
                .padding()
                
                HStack {
                    Text("Tap to start writing...")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .fontDesign(.serif).italic()
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Spacer()
                }
                .padding()
            }
        }
    }
}
