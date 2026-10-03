//
//  WhatsNewView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/10/24.
//

import ColorfulX
import SwiftUI

/// View displayed after the user updates the app, showcasing new features and improvements introduced.
struct WhatsNewView: View {
    @Environment(\.dismiss) var dismiss
    @State var gradientColors: [Color] = [.white, .cleanPadIconBackground, .white]
    @State var gradientSpeed: Double = 0.4
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                ColorfulView(color: $gradientColors, speed: $gradientSpeed)
                    .opacity(0.9)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .center) {
                        Spacer()
                        headerView
                        detailsView
                        Spacer()
                    }
                    .frame(
                        maxWidth: geometry.size.width,
                        minHeight: geometry.size.height
                    )
                    .padding(.horizontal)
                }
                
                VStack {
                    Spacer()
                    dismissButtonView
                }
            }
            .frame(maxWidth: geometry.size.width)
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Extension to group secondary views in WhatsNewView.
extension WhatsNewView {
    /// Header view containing the "What's New" Text.
    var headerView: some View {
        HStack {
            Text("What's New in CleanPad")
                .multilineTextAlignment(.leading)
                .foregroundStyle(.black)
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            Spacer()
        }
    }
    
    /// Detailed view explaining the changes in the new version of the app.
    var detailsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            NewFeatureView(
                imageSystemName: "drop",
                featureTitle: "Liquid Glass, refined",
                featureDescription: "The Dock now flows (and glows) more naturally on iOS 26+, with a more seamless Liquid Glass experience."
            )
            
            NewFeatureView(
                imageSystemName: "hand.point.up.left",
                featureTitle: "Smoother interactions",
                featureDescription: "Refined controls bring more fluid animations throughout CleanPad."
            )
            
            NewFeatureView(
                imageSystemName: "magnifyingglass",
                featureTitle: "Search, right where you need it",
                featureDescription: "Search now lives outside the Dock, giving navigation more room while keeping search easy to access."
            )
        }
        .padding(.vertical)
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
    
    /// View to display the description of a new feature.
    fileprivate struct NewFeatureView: View {
        let imageSystemName: String
        let featureTitle: String
        let featureDescription: String
        
        @State private var animate = false

        var body: some View {
            HStack(alignment: .center) {
                Image(systemName: imageSystemName)
                    .foregroundStyle(.accent.gradient)
                    .font(.system(size: 30))
                    .symbolEffect(
                        .bounce,
                        options: .speed(0.6),
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
