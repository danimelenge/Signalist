//
//  WhatsNewView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 10/07/26.
//

import SwiftUI

// MARK: - WhatsNewView

struct WhatsNewView: View {
    
    // MARK: - Properties
    
    let features: [WhatsNewFeature]
    let headerIcon: String
    let onContinue: () -> Void
    
    @AppStorage("appTheme")
    private var appTheme: AppTheme = .system
    
    // MARK: - Initializer
    
    /// Valor por defecto para no romper llamadas existentes.
    init(
        features: [WhatsNewFeature],
        headerIcon: String = "dot.radiowaves.left.and.right",
        onContinue: @escaping () -> Void
    ) {
        self.features = features
        self.headerIcon = headerIcon
        self.onContinue = onContinue
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Header
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Theme.brandGradient)
                        .frame(width: 72, height: 72)
                        .shadow(
                            color: Theme.gradientEnd.opacity(0.35),
                            radius: 12,
                            y: 4
                        )
                    
                    Image(systemName: headerIcon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.top, 32)
                
                Text("Novedades en Signalist")
                    .font(
                        .system(
                            size: 26,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                
                Text("Todo lo que puedes hacer con la nueva versión")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 20)
            
            // MARK: - Feature List
            
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    ForEach(features) { feature in
                        FeatureRow(feature: feature)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 8)
            }
            
            // MARK: - Divider
            
            Divider()
            
            // MARK: - Continue Button
            
            Button(action: onContinue) {
                Text("Continuar")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(20)
        }
        .frame(width: 480, height: 620)
        .background(Color(nsColor: .windowBackgroundColor))
        .preferredColorScheme(appTheme.colorScheme)
    }
}

// MARK: - Feature Row

private struct FeatureRow: View {
    
    // MARK: - Properties
    
    let feature: WhatsNewFeature
    
    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            // MARK: Feature Icon
            
            Image(systemName: feature.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(feature.iconColor)
                .frame(width: 24)
            
            // MARK: Feature Information
            
            VStack(alignment: .leading, spacing: 3) {
                Text(feature.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text(feature.description)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }
        }
    }
}

// MARK: - Previews

#Preview {
    WhatsNewView(
        features: WhatsNewFeature.currentFeatures,
        onContinue: {}
    )
}

#Preview("Braille icon") {
    WhatsNewView(
        features: WhatsNewFeature.currentFeatures,
        headerIcon: "hand.point.up.braille.fill",
        onContinue: {}
    )
}

#Preview("Dark") {
    WhatsNewView(
        features: WhatsNewFeature.currentFeatures,
        onContinue: {}
    )
    .preferredColorScheme(.dark)
}
