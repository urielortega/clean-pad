//
//  HelperViews.swift
//  CleanPad
//
//  Created by Uriel Ortega on 17/10/23.
//

import SwiftUI

struct CustomHStackDivider: View {
    var width: Double = 2
    var height: Double = 30
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .foregroundStyle(.secondary)
    }
}

/// View to display a Custom Title at the top leading corner.
struct CustomTopTitle: View {
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.title)
                .bold()
            
            Spacer()
        }
    }
}

/// View to place Dismiss Button at the top trailing corner.
struct TopDismissViewButton: View {
    var body: some View {
        HStack {
            Spacer()
            DismissViewButton()
        }
        .padding(.horizontal)
    }
}

struct AppIconView: View {
    var body: some View {
        Image(decorative: "CleanPadIcon")
            .resizable()
            .frame(width: 100, height: 100)
            .clipShape(.rect(cornerRadius: Constants.appIconCornerRadius))
            .shadow(radius: Constants.iconShadowRadius)
    }
}

/// View that displays a circular indicator representing the color of a note's category.
struct NoteCategoryIndicator: View {
    var note: Note
    
    var body: some View {
        Circle()
            .fill(note.category?.color.gradient ?? Color.gray.gradient)
            .frame(width: 10, height: 10)
    }
}
