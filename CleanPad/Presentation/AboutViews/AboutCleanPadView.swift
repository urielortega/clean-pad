//
//  AboutCleanPadView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 18/01/24.
//

import ColorfulX
import SwiftUI

/// View containing fundamental information about the purpose and operation of the app, accessible at anytime for the user.
struct AboutCleanPadView: View {
    @State private var greeting = "Hello!"
    @State var gradientColors: [Color] = ColorfulPreset.aurora.colors
    @State var gradientSpeed: Double = 0.4
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                ColorfulView(color: $gradientColors, speed: $gradientSpeed)
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
                            .padding([.top, .horizontal])
                    }
                    .frame(maxWidth: geometry.size.width)
                    
                    Spacer()
                }
            }
            .frame(maxWidth: geometry.size.width)
            .multilineTextAlignment(.center)
            .onAppear(perform: updateBackgroundAndGreeting)
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(Constants.roundedRectCornerRadius)
        }
    }
}

// MARK: - Extension to group secondary views in AboutCleanPadView.
extension AboutCleanPadView {
    /// Header view displaying the app icon and a dynamic greeting based on the time of day.
    var headerView: some View {
        Group {
            AppIconView()
                .padding()
                .padding(.top, 50)
            
            Text(greeting)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(Material.thick)
                .shadow(radius: Constants.textShadowRadius)
        }
    }
    
    /// Detailed view providing an overview of CleanPad's purpose and a thank-you message to users.
    var detailsView: some View {
        VStack {
            VStack {
                Text("CleanPad is the home for any of your thoughts.")
                    .font(.title)
                    .foregroundStyle(Material.regular)
                    .padding(.bottom)
                
                Group {
                    Text("It’s your space to capture it all. Feel free to express yourself.")
                    Text("Your notes are yours alone, securely stored on your device and optionally protected with authentication.")
                }
                .foregroundStyle(Material.thick)
            }
            .padding(.bottom)
            
            Text("Thank you for choosing CleanPad as your trusted companion. Here's to a clutter-free, inspired note-taking journey!")
                .foregroundStyle(Material.thick)
                .padding(.bottom)
        }
        .fixedSize(horizontal: false, vertical: true)
        .fontWeight(.semibold)
        .shadow(radius: Constants.textShadowRadius)
        .padding(.horizontal)
    }
    
    /// Method for updating the background gradient and greeting text based on the current time of day.
    private func updateBackgroundAndGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12:
            greeting = "Good morning!"
            gradientColors = ColorfulPreset.sunrise.colors
        case 12..<17:
            greeting = "Good afternoon!"
            gradientColors = ColorfulPreset.lemon.colors
        case 17..<20:
            greeting = "Good evening!"
            gradientColors = ColorfulPreset.sunrise.colors
        default:
            greeting = "Good night!"
            gradientColors = ColorfulPreset.jelly.colors
        }
    }
}



#Preview {
    AboutCleanPadView()
}
