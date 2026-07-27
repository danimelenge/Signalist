//
//  WhatsNewFeature.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 10/07/26.
//

import SwiftUI

// MARK: - What's New Feature Model

/// Modelo que representa una característica mostrada
/// en la ventana de novedades de Signalist.
struct WhatsNewFeature: Identifiable {

    // MARK: - Properties

    /// Identificador único para SwiftUI.
    let id = UUID()

    /// Nombre del SF Symbol que representa la característica.
    let icon: String

    /// Color del icono.
    let iconColor: Color

    /// Título de la característica.
    let title: String

    /// Descripción breve de la característica.
    let description: String
}

// MARK: - Current Features

extension WhatsNewFeature {

    /// Lista de novedades mostradas en la versión actual de Signalist.
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
    ]

    // MARK: - TODO

    // TODO: Mostrar automáticamente las novedades
    // correspondientes a cada versión de la aplicación.

    // TODO: Cargar las novedades desde un archivo JSON
    // para facilitar su mantenimiento.

    // MARK: - FIXME

    // FIXME: Localizar los textos para soportar
    // múltiples idiomas mediante Localizable.strings.

    // MARK: - NOTE

    // NOTE: Cada elemento de currentFeatures se muestra
    // automáticamente en WhatsNewView mediante un ForEach.
}
