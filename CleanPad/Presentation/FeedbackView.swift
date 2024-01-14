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
        VStack {
            headerView
            detailsView
            
            VStack {
                HStack {
                    iMessageButtonView
                    buyMeACoffeeButtonView
                }
                .padding(.horizontal)
                
                dismissButtonView
            }
        }
        .presentationDetents([.fraction(0.8)])
        .presentationDragIndicator(.visible)
    }
    
    var headerView: some View {
        Group {
            Image("memoji")
                .resizable()
                .frame(width: 100, height: 100)
                .shadow(radius: 10)
                .padding(.top)
            
            Text("Hello! This is Uriel.")
                .font(.title).bold()
                .padding()
        }
    }
    
    var detailsView: some View {
        Group {
            Text("Feel free to reach out and share your thoughts with me!")
                .bold()
                .multilineTextAlignment(.center)
            
            Text("Whether it's a bug report, a suggestion, or just a friendly chat—I'm here for you.")
                .bold()
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)

            Text("If you enjoy using the app and would like to support my work, you can also buy me a coffee. Every sip fuels more improvements for this and future apps. Thank you! ☕️✨")
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
    
    var iMessageButtonView: some View {
        Button {
            if let url = URL(string: "sms:urielortega2509@gmail.com") {
                UIApplication.shared.open(url)
            }
        } label: {
            Label("iMessage Me", systemImage: "message.fill")
                .labelStyle(.iconOnly)
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
                .labelStyle(.iconOnly)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.primary, lineWidth: 2)
                )
        }
    }
    
    var dismissButtonView: some View {
        Button {
            dismiss()
        } label: {
            Text("Great!")
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(.brown)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding()
        }
    }
}

#Preview {
    FeedbackView()
}
