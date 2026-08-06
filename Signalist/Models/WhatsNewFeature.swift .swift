//
//  WhatsNewFeature.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 10/07/26.
//

import SwiftUI

/// Representa una característica o novedad mostrada
/// en la pantalla "What's New" de Signalist.
struct WhatsNewFeature: Identifiable {

    // MARK: - Properties

    /// Identificador único para SwiftUI.
    let id = UUID()

    /// Nombre del SF Symbol que representa la característica.
    let icon: String

    /// Color utilizado para el icono.
    let iconColor: Color

    /// Título principal de la novedad.
    let title: String

    /// Descripción breve de la funcionalidad.
    let description: String
}

// MARK: - Current Features

extension WhatsNewFeature {

    /// Lista de funcionalidades disponibles en la versión actual
    /// de Signalist. Se muestra automáticamente en la pantalla
    /// "What's New".
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

    // TODO: Mostrar únicamente las novedades agregadas desde la última versión instalada.

    // MARK: - FIXME

    // FIXME: Localizar títulos y descripciones para soportar múltiples idiomas.

    // MARK: - NOTE

    // NOTE: Esta lista se utiliza como fuente de datos para WhatsNewView.
    // Al agregar una nueva funcionalidad a Signalist, se recomienda incluir
    // aquí una nueva entrada para que los usuarios conozcan las novedades
    // al actualizar la aplicación.
}
