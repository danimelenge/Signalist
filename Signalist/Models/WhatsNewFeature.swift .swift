//
//  WhatsNewFeature.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 10/07/26.
//

import SwiftUI

// MARK: - What's New Feature Model

/// Represents a single feature entry displayed in the "What's New" screen.
struct WhatsNewFeature: Identifiable {

    // MARK: - Properties

    let id = UUID()
    let icon: String
    let iconColor: Color
    let title: String
    let description: String

    // TODO:
    // Support localized titles and descriptions in future versions.
}

// MARK: - Current Features

extension WhatsNewFeature {

    /// The full list of features currently announced in the app.
    /// This list is shown every time the user taps the sparkles (✨)
    /// button, and automatically on first launch.
    static let currentFeatures: [WhatsNewFeature] = [

        WhatsNewFeature(
            icon: "dot.radiowaves.left.and.right",
            iconColor: .blue,
            title: "Conversión instantánea",
            description: "Escribe texto y obtén el código Morse al instante, sin botones extra."
        ),

        WhatsNewFeature(
            icon: "arrow.left.arrow.right",
            iconColor: .indigo,
            title: "Doble dirección",
            description: "Convierte de texto a Morse o de Morse a texto con un solo toque."
        ),

        WhatsNewFeature(
            icon: "hand.point.up.braille.fill",
            iconColor: .teal,
            title: "Nueva pestaña de Braille",
            description: "Convierte texto a Braille Unicode y viceversa, incluyendo mayúsculas y números, desde la pestaña \"Braille\"."
        ),

        WhatsNewFeature(
            icon: "antenna.radiowaves.left.and.right",
            iconColor: .red,
            title: "Nueva pestaña de NATO",
            description: "Convierte texto al alfabeto fonético NATO (Alfa, Bravo, Charlie...) y viceversa, desde la pestaña \"NATO\"."
        ),

        WhatsNewFeature(
            icon: "number",
            iconColor: .cyan,
            title: "Nueva pestaña de Binario",
            description: "Convierte texto a código binario de 8 bits y viceversa, desde la pestaña \"Binario\"."
        ),

        WhatsNewFeature(
            icon: "textformat.123",
            iconColor: .brown,
            title: "Nueva pestaña de ASCII",
            description: "Convierte texto a códigos ASCII decimales y viceversa, desde la pestaña \"ASCII\"."
        ),

        WhatsNewFeature(
            icon: "character.book.closed.fill",
            iconColor: .indigo,
            title: "Nueva pestaña de Unicode",
            description: "Convierte texto a puntos de código Unicode (incluyendo emojis) y viceversa, desde la pestaña \"Unicode\"."
        ),

        WhatsNewFeature(
            icon: "chevron.left.forwardslash.chevron.right",
            iconColor: .blue,
            title: "Nueva pestaña de Base64",
            description: "Convierte texto a Base64 y viceversa, ideal para usar en emails, URLs o JSON, desde la pestaña \"Base64\"."
        ),

        WhatsNewFeature(
            icon: "speaker.wave.2.fill",
            iconColor: .orange,
            title: "Sonido Morse",
            description: "Escucha el código Morse mientras lo generas, con tonos reales de radiotelegrafía. Silencia el audio cuando quieras desde la barra de herramientas."
        ),

        WhatsNewFeature(
            icon: "circle.lefthalf.filled",
            iconColor: .purple,
            title: "Modo claro y oscuro",
            description: "Elige tu apariencia favorita o deja que Signalist siga al sistema."
        ),

        WhatsNewFeature(
            icon: "doc.on.doc",
            iconColor: .green,
            title: "Copiar con un clic",
            description: "Copia el resultado al portapapeles y pégalo donde lo necesites."
        )

        // TODO:
        // Add a new entry here each time a new feature or tab is shipped,
        // so returning users see it the next time they open "Novedades".
    ]

    // FIXME:
    // This list is static and shows every feature ever added, regardless
    // of when the user first installed the app. Consider adopting a
    // version-based system (e.g. WhatsNewVersion) so only features from
    // versions newer than the user's `lastSeenVersion` are shown
    // automatically, instead of the full history every time.

    // NOTE:
    // Icon colors are chosen to roughly match each feature's home screen
    // (blue/indigo = Morse, teal/mint = Braille, red/pink = NATO,
    // cyan/yellow = Binario, brown/gray = ASCII, indigo/purple = Unicode,
    // blue/orange = Base64) for visual consistency with HelpView.
}
