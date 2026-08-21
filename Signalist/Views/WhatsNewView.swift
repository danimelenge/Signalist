//
//  WhatsNewView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 10/07/26.
//

import SwiftUI

// MARK: - WhatsNewView

/// Vista que muestra las novedades y funcionalidades disponibles
/// en la versión actual de Signalist.
struct WhatsNewView: View {

    // MARK: - Properties

    /// Lista de funcionalidades que se mostrarán en la vista.
    let features: [WhatsNewFeature]

    /// SF Symbol utilizado como icono principal del encabezado.
    let headerIcon: String

    /// Acción ejecutada cuando el usuario pulsa el botón "Continuar".
    let onContinue: () -> Void

    /// Tema visual seleccionado por el usuario.
    @AppStorage("appTheme")
    private var appTheme: AppTheme = .system

    // MARK: - Initializer

    /// Inicializa la vista de novedades.
    ///
    /// - Parameters:
    ///   - features: Funcionalidades que se mostrarán en la lista.
    ///   - headerIcon: Icono utilizado en el encabezado.
    ///   - onContinue: Acción ejecutada al continuar.
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

            // MARK: Feature List

            /// Lista desplazable con las funcionalidades disponibles.
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    ForEach(features) { feature in
                        FeatureRow(feature: feature)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 8)
            }

            // MARK: Divider

            Divider()

            // MARK: Continue Button

            /// Botón que permite cerrar la pantalla de novedades.
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

    // MARK: - TODO

    // TODO: Agregar animaciones de entrada para cada funcionalidad.

    // MARK: - FIXME

    // FIXME: Revisar el tamaño de la ventana para garantizar una correcta
    // visualización cuando se agreguen nuevas funcionalidades.

    // MARK: - NOTE

    // NOTE: El icono del encabezado puede cambiar dependiendo de la pestaña
    // seleccionada en RootView.
}

// MARK: - Feature Row

/// Fila reutilizable que representa una funcionalidad de Signalist.
private struct FeatureRow: View {

    // MARK: - Properties

    /// Información de la funcionalidad que se mostrará.
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

    // MARK: - NOTE

    // NOTE: FeatureRow es privada porque únicamente se utiliza dentro
    // de WhatsNewView.
}

// MARK: - Previews

#Preview {
    WhatsNewView(
        features: WhatsNewFeature.currentFeatures,
        onContinue: {}
    )
}

// MARK: - Braille Preview

#Preview("Braille icon") {
    WhatsNewView(
        features: WhatsNewFeature.currentFeatures,
        headerIcon: "hand.point.up.braille.fill",
        onContinue: {}
    )
}

// MARK: - Dark Preview

#Preview("Dark") {
    WhatsNewView(
        features: WhatsNewFeature.currentFeatures,
        onContinue: {}
    )
    .preferredColorScheme(.dark)
}
