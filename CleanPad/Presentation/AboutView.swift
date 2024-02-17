//
//  AboutView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 18/01/24.
//

import SwiftUI

/// View containing fundamental information about the purpose and operation of the app, accesible at anytime for the user.
struct AboutView: View {
    @State private var greeting = "Good morning!"
    @State private var backgroundImage = "sunrise"
    @State private var textForegroundColor = Color.black
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                backgroundView
                
                ScrollView {
                    VStack {
                        Spacer()
                        headerView
                        detailsView
                        Spacer()
                        dismissButtonView
                    }
                    .frame(maxWidth: geometry.size.width, minHeight: geometry.size.height)
                    .padding()
                }
            }
            .frame(maxWidth: geometry.size.width)
            .multilineTextAlignment(.center)
            .foregroundStyle(textForegroundColor)
            .fontDesign(.rounded)
            .onAppear(perform: updateBackgroundImageAndGreeting)
            .presentationDragIndicator(.visible)
        }
    }
    
    var backgroundView: some View {
        Image(decorative: backgroundImage)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .blur(radius: 20, opaque: true)
    }
    
    var headerView: some View {
        Group {
            Image(decorative: "CleanPadIcon")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 23.0))
                .shadow(radius: 7)
                .padding()
                .padding(.top, 50)
            
            Text(greeting)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)
        }
    }
    
    var detailsView: some View {
        VStack {
            VStack {
                Text("CleanPad is the home for any of your thoughts.")
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
                
                Text("It’s your space to capture it all. Feel free to express yourself.")
                Text("Your notes are yours alone, securely stored on your device and optionally protected with authentication.")
            }
            .padding(.bottom)
            
            Text("Thank you for choosing CleanPad as your trusted companion. Here's to a clutter-free, inspired note-taking journey!")
                .padding(.bottom)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal)
    }
    
    var dismissButtonView: some View {
        Button {
            dismiss()
        } label: {
            Text("Great!")
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(radius: 10)
                .padding()
        }
        .padding(.bottom, 100)
    }
    
    private func updateBackgroundImageAndGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12:
            greeting = "Good morning!"
            backgroundImage = "sunrise"
            textForegroundColor = .black
        case 12..<17:
            greeting = "Good afternoon!"
            backgroundImage = "daylight"
            textForegroundColor = .black
        case 17..<20:
            greeting = "Good evening!"
            backgroundImage = "sunset"
            textForegroundColor = .white
        default:
            greeting = "Good night!"
            backgroundImage = "night"
            textForegroundColor = .white
        }
    }
}



#Preview {
    AboutView()
}
