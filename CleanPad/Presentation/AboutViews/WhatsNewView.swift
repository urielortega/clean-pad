//
//  WhatsNewView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/10/24.
//

import ColorfulX
import SwiftUI

struct WhatsNewView: View {
    @Environment(\.dismiss) var dismiss
    @State var gradientColors: [Color] = [.white, .cleanPadIconBackground, .white]
    @State var gradientSpeed: Double = 0.4
    
    var body: some View {
        ZStack(alignment: .center) {
            ColorfulView(color: $gradientColors, speed: $gradientSpeed)
                .opacity(0.9)
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Spacer()
                headerView
                detailsView
                Spacer()
                dismissButtonView
            }
        }
        .presentationCornerRadius(Constants.roundedRectCornerRadius)
    }
}

// MARK: - Extension to group secondary views in WelcomeView.
extension WhatsNewView {
    /// Header view containing the "What's New" Text.
    var headerView: some View {
        EmptyView()
    }
    
    /// Detailed view explaining the changes in the new version of the app.
    var detailsView: some View {
        VStack(alignment: .leading) {
            NewFeatureView(
                imageSystemName: "line.3.horizontal.decrease.circle.fill",
                featureTitle: "Every thought finds its place",
                featureDescription: "Easily create and assign categories to organize your notes better"
            )
            
            NewFeatureView(
                imageSystemName: "lock.fill",
                featureTitle: "Your private notes, still personal",
                featureDescription: "Personal Notes are now called Private Notes to make things clearer"
            )
            
            NewFeatureView(
                imageSystemName: "sparkles",
                featureTitle: "A smoother, comfier experience",
                featureDescription: "Say hello to a refreshed interface that makes CleanPad smoother, more intuitive, and easier to navigate"
            )
        }
        .padding(.vertical)
        .presentationCornerRadius(Constants.roundedRectCornerRadius)
    }
    
    /// Button for dismissing the What's New screen.
    var dismissButtonView: some View {
        Button {
            HapticManager.instance.impact(style: .soft)
            dismiss()
        } label: {
            MaterialButtonLabel(labelText: "Great!")
        }
        .padding()
    }
    
    fileprivate struct NewFeatureView: View {
        let imageSystemName: String
        let featureTitle: String
        let featureDescription: String
        
        @State private var animate = false

        var body: some View {
            HStack(alignment: .center) {
                Image(systemName: imageSystemName)
                    .foregroundStyle(.accent.gradient)
                    .font(.system(size: 40))
                    .symbolEffect(
                        .bounce,
                        options: .speed(0.8),
                        value: animate
                    )
                    .frame(width: 40)
                    .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text(featureTitle)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.black)
                        .font(.title3)
                        .bold()
                    
                    Text(featureDescription)
                        .foregroundStyle(.black.opacity(0.7))
                }
            }
            .padding(.vertical)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    animate.toggle()
                }
            }
        }
    }
}


#Preview {
    WhatsNewView()
}
