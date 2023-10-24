//
//  WelcomeView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 03/10/23.
//

import SwiftUI

/// View shown on the first app launch, containing fundamental information about the purpose and operation of the app.
struct WelcomeView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            headerView
            detailsView
            Spacer()
            dismissButtonView
        }
    }
    
    var headerView: some View {
        Group {
            Image("CleanPadIcon")
                .resizable()
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 35.0))
                .shadow(radius: 7)
                .padding(.bottom, 40)
            
            Text("Welcome to CleanPad")
                .font(.title).bold()
                .padding(.bottom, 20)
        }
    }
    
    var detailsView: some View {
        Group {
            Text("This app is your canvas for capturing your thoughts, feelings, ideas and all you can imagine.")
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            Text("Feel free to write anything you like. Your data is securely stored on your device and can be protected with authentication if you choose.")
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            Text("Enjoy it! 🫶🏼")

        }
        .padding(.horizontal)
    }
    
    var dismissButtonView: some View {
        Button {
            dismiss()
        } label: {
            Text("Great!")
                .frame(width: 300, height: 50)
                .background(.brown)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                .padding(.bottom, 50)
        }
    }
}

#Preview {
    WelcomeView()
}
