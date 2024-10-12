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
        EmptyView()
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
        
        var body: some View {
            HStack(alignment: .center) {
                Image(systemName: imageSystemName)
                    .foregroundStyle(.accent.gradient)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading) {
                    Text(featureTitle)
                        .multilineTextAlignment(.leading)
                        .font(.title3)
                        .bold()
                    
                    Text(featureDescription)
                        .foregroundStyle(.secondary)
                    
                }
            }
            .padding(.vertical)
        }
    }
}


#Preview {
    WhatsNewView()
}
