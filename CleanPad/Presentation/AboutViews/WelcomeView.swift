//
//  WelcomeView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 03/10/23.
//

import ColorfulX
import SwiftUI

/// View shown on the first app launch, containing fundamental information about the purpose and operation of the app.
struct WelcomeView: View {
    @Environment(\.dismiss) var dismiss
    @State var gradientColors: [Color] = [.brown, .white, .gray]
    @State var gradientSpeed: Double = 0.4
    
    var body: some View {
        ZStack(alignment: .center) {
            ColorfulView(color: $gradientColors, speed: $gradientSpeed)
                .opacity(0.8)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                headerView
                detailsView
                Spacer()
                dismissButtonView
            }
        }
    }
    
    var headerView: some View {
        Group {
            Image(decorative: "CleanPadIcon")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(.rect(cornerRadius: 23))
                .shadow(radius: Constants.iconShadowRadius)
                .padding(.bottom, 40)
            
            Group {
                Text("Welcome to CleanPad")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.black)
                
                Text("The home for your thoughts")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black.opacity(0.7))
                    .padding(.bottom, 20)
            }
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
        .fontWeight(.semibold)
        .foregroundStyle(.black)
        .padding(.horizontal)
    }
    
    var dismissButtonView: some View {
        Button {
            HapticManager.instance.impact(style: .soft)
            dismiss()
        } label: {
            MaterialButtonLabel(labelText: "Great!")
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
