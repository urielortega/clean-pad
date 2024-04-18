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
            Label("iMessage Me", systemImage: "message.fill")
                .labelStyle(.automatic)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.primary, lineWidth: 2)
                )
        }
    }
    
    var buyMeACoffeeButtonView: some View {
        Link(destination: URL(string: "https://www.buymeacoffee.com/urielortega")!) {
            Label("Buy Me A Coffee", systemImage: "cup.and.saucer.fill")
                .labelStyle(.automatic)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.primary, lineWidth: 2)
                )
        }
    }
}

#Preview {
    FeedbackView()
}
