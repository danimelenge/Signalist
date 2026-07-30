//
//  WhatsNewView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 10/07/26.
//

import SwiftUI

// MARK: - Vista de Novedades

/// Pantalla que muestra las novedades y características
/// disponibles en la versión actual de Signalist.
struct WhatsNewView: View {

    // MARK: - Propiedades

    /// Lista de funcionalidades que se mostrarán.
    let features: [WhatsNewFeature]

    /// Ícono principal del encabezado.
    let headerIcon: String

    /// Acción ejecutada al pulsar el botón Continuar.
    let onContinue: () -> Void

    /// Tema seleccionado por el usuario.
    @AppStorage("appTheme")
    private var appTheme: AppTheme = .system

    // MARK: - Inicializador

    /// Crea la vista de novedades.
    ///
    /// - Parameters:
    ///   - features: Lista de características a mostrar.
    ///   - headerIcon: SF Symbol del encabezado.
    ///   - onContinue: Acción del botón Continuar.
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

            // MARK: Encabezado

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
                .padding(.top, 36)

                Text("Novedades en Signalist")
                    .font(.system(size: 26, weight: .bold, design: .rounded))

                Text("Todo lo que puedes hacer con la nueva versión")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 28)

            // MARK: Lista de funcionalidades

            VStack(alignment: .leading, spacing: 22) {
                ForEach(features) { feature in
                    FeatureRow(feature: feature)
                }
            }
            .padding(.horizontal, 40)

            Spacer(minLength: 28)

            // MARK: Botón Continuar

            Button(action: onContinue) {
                Text("Continuar")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 40)
            .padding(.bottom, 32)
        }
        .frame(width: 460)
        .background(Color(nsColor: .windowBackgroundColor))
        .preferredColorScheme(appTheme.colorScheme)
    }
}

// MARK: - Fila de Funcionalidad

/// Representa una característica individual dentro
/// de la pantalla de novedades.
private struct FeatureRow: View {

    // MARK: - Propiedades

    let feature: WhatsNewFeature

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top, spacing: 16) {

            Image(systemName: feature.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(feature.iconColor)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 3) {

                Text(feature.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(feature.description)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
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
