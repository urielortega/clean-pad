//
//  AboutCleanPadView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 18/01/24.
//

import ColorfulX
import SwiftUI

/// View containing fundamental information about the purpose and operation of the app, accesible at anytime for the user.
struct AboutCleanPadView: View {
    @State private var greeting = "Hello!"
    @State private var textForegroundColor = Color.white
    @State var gradientColors: [Color] = ColorfulPreset.aurora.colors
    @State var gradientSpeed: Double = 0.3
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                ColorfulView(color: $gradientColors, speed: $gradientSpeed)
                    .opacity(0.8)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        Spacer()
                        headerView
                        detailsView
                        Spacer()
                        Spacer()
                    }
                    .frame(
                        maxWidth: geometry.size.width, 
                        minHeight: geometry.size.height
                    )
                    .padding(.horizontal)
                }
                
                // View for Dismiss Button:
                VStack {
                    HStack {
                        Spacer()
                        
                        DismissViewButton()
                            .padding(.top)
                    }
                    .frame(maxWidth: geometry.size.width)
                    
                    Spacer()
                }
            }
            .frame(maxWidth: geometry.size.width)
            .multilineTextAlignment(.center)
            .foregroundStyle(textForegroundColor)
            .onAppear(perform: updateBackgroundAndGreeting)
            .presentationDragIndicator(.visible)
        }
    }
    
    var headerView: some View {
        Group {
            Image(decorative: "CleanPadIcon")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(.rect(cornerRadius: 23))
                .shadow(radius: 7)
                .padding()
                .padding(.top, 50)
            
            Text(greeting)
                .font(.largeTitle)
                .fontWeight(.bold)
                .fontDesign(.serif)
                .padding(.bottom)
        }
    }
    
    var detailsView: some View {
        VStack {
            VStack {
                Text("CleanPad is the home for any of your thoughts.")
                    .font(.title2)
                    .fontDesign(.serif)
                    .padding(.bottom)
                
                Text("It’s your space to capture it all. Feel free to express yourself.")
                Text("Your notes are yours alone, securely stored on your device and optionally protected with authentication.")
            }
            .padding(.bottom)
            
            Text("Thank you for choosing CleanPad as your trusted companion. Here's to a clutter-free, inspired note-taking journey!")
                .padding(.bottom)
        }
        .fixedSize(horizontal: false, vertical: true)
        .fontWeight(.semibold)
        .padding(.horizontal)
    }
    
    private func updateBackgroundAndGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12:
            greeting = "Good morning!"
            gradientColors = ColorfulPreset.sunrise.colors
            textForegroundColor = .black
        case 12..<17:
            greeting = "Good afternoon!"
            gradientColors = ColorfulPreset.lemon.colors
            textForegroundColor = .black
        case 17..<20:
            greeting = "Good evening!"
            gradientColors = ColorfulPreset.sunrise.colors
            textForegroundColor = .black
        default:
            greeting = "Good night!"
            gradientColors = ColorfulPreset.jelly.colors
            textForegroundColor = .white
        }
    }
}



#Preview {
    AboutCleanPadView()
}
