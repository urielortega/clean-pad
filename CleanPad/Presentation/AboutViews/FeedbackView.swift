//
//  FeedbackView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 11/12/23.
//

import SwiftUI

/// View shown on the first app launch, containing fundamental information about the purpose and operation of the app.
struct FeedbackView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                ScrollView {
                    HStack {
                        VStack {
                            Spacer()
                            headerView
                                .padding()
                            detailsView
                                .padding(.horizontal)
                            Spacer()
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .frame(
                        maxWidth: geometry.size.width,
                        minHeight: geometry.size.height
                    )
                }
                
                // View for Support and Dismiss buttons:
                VStack {
                    HStack {
                        Spacer()
                        
                        DismissViewButton()
                            .padding(.top)
                    }
                    
                    Spacer()
                    
                    VStack {
                        iMessageButtonView
                        buyMeACoffeeButtonView
                    }
                    .padding()
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(roundedRectCornerRadius)
    }
    
    var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hello! 👋🏼")
                    .font(.title)
                    .bold()
                
                Text("I'm Uriel Ortega.")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            .fontDesign(.monospaced)
            
            Spacer()
        }
    }
    
    var detailsView: some View {
        VStack(alignment: .leading) {
            Text("Feel free to reach out and share your thoughts with me!")
                .bold()
                .multilineTextAlignment(.leading)
            
            Text("Whether it's a bug report, a suggestion, or just a friendly chat—I'm here for you.")
                .bold()
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
            
            Text("If you enjoy using the app and would like to support my work, you can also buy me a coffee. Every sip fuels more improvements for this and future apps. Thank you! ☕️✨")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
        }
    }
    
    var iMessageButtonView: some View {
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
    
    var buyMeACoffeeButtonView: some View {
        Link(destination: URL(string: "https://www.buymeacoffee.com/urielortega")!) {
            BorderedButtonLabel(
                color: .black.opacity(0.8),
                labelText: "Buy Me A Coffee",
                systemImageString: "cup.and.saucer.fill"
            )
        }
    }
}

#Preview {
    FeedbackView()
}
