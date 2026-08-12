//
//  FeedbackView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 11/12/23.
//

import SwiftUI

/// A feedback and support sheet that lets users contact the developer or support the app.
struct FeedbackView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    headerView
                    detailsView
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    DismissViewButton()
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .bottom) {
                // Action Buttons anchored at the bottom
                VStack {
                    iMessageButtonView
                    buyMeACoffeeButtonView
                }
                .padding()
            }
        }
        .presentationDetents([.fraction(0.7)])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Extension to group secondary views in FeedbackView.

extension FeedbackView {
    /// Header view displaying a greeting and the developer's name.
    var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hello! 👋🏼")
                    .font(.largeTitle)
                    .bold()
                
                Text("I'm Uriel Ortega.")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
    
    /// Detailed view providing information on how users can reach out, give feedback, or support the developer.
    var detailsView: some View {
        VStack(alignment: .leading) {
            Text("Feel free to reach out and share your thoughts with me!")
                .bold()
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Whether it's a bug report, a suggestion, or just a friendly chat—I'm here for you.")
                .bold()
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 10)
            
            Text("If you enjoy using the app and would like to support my work, you can also buy me a coffee. Every sip fuels more improvements for this and future apps. Thank you! ☕️✨")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 60)
        }
        .accessibilityElement()
        .accessibilityLabel("Feel free to provide feedback or support my work by using the buttons below.")
    }
    
    /// Button for sending an iMessage to the developer.
    var iMessageButtonView: some View {
        Group {
            if #available(iOS 26.0, *) {
                Button() {
                    if let url = URL(string: "sms:urielortega2509@gmail.com") {
                        UIApplication.shared.open(url)
                    }
                } label : {
                    Label("iMessage Me", systemImage: "message.fill")
                        .labelStyle(.automatic)
                        .foregroundStyle(.white)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 50, alignment: .center)
                }
                .buttonStyle(.glassProminent)
                .tint(.green)
            } else {
                Button {
                    if let url = URL(string: "sms:urielortega2509@gmail.com") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    BorderedButtonLabel(
                        color: .green,
                        labelText: "iMessage Me",
                        systemImageString: "message.fill"
                    )
                }
            }
        }
    }
    
    /// Button for supporting the developer through Buy Me a Coffee.
    var buyMeACoffeeButtonView: some View {
        Group {
            if #available(iOS 26.0, *) {
                Link(destination: URL(string: "https://www.buymeacoffee.com/urielortega")!) {
                    Label("Buy Me A Coffee", systemImage: "cup.and.saucer.fill")
                        .labelStyle(.automatic)
                        .foregroundStyle(.white)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 50, alignment: .center)
                }
                .buttonStyle(.glassProminent)
                .tint(.black.opacity(0.8))
            } else {
                Link(destination: URL(string: "https://www.buymeacoffee.com/urielortega")!) {
                    BorderedButtonLabel(
                        color: .black.opacity(0.8),
                        labelText: "Buy Me A Coffee",
                        systemImageString: "cup.and.saucer.fill"
                    )
                }
            }
        }
    }
}

#Preview {
    FeedbackView()
}
