//
//  CategoryManagementView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 26/02/24.
//

import SwiftUI

struct CategoryManagementView: View {
    var body: some View {
        Text("Hello, Categories!")
            .presentationDetents([.fraction(0.4)])
            .presentationDragIndicator(.visible)
            .presentationBackground(.ultraThinMaterial)
    }
}

#Preview {
    CategoryManagementView()
}
