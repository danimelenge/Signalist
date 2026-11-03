//
//  AccessibilitySupport.swift
//  Signalist
//
//  Modificadores reutilizables de accesibilidad (VoiceOver, Reducir
//  movimiento) compartidos por todas las pestañas de conversión.
//

import SwiftUI

// MARK: - Reduce Motion

/// Aplica una animación solo cuando el usuario NO tiene activada la opción
/// "Reducir movimiento" en Ajustes del Sistema → Accesibilidad → Pantalla.
private struct MotionSafeAnimation<Value: Equatable>: ViewModifier {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let animation: Animation
    let value: Value

    func body(content: Content) -> some View {
        content.animation(reduceMotion ? nil : animation, value: value)
    }
}

// MARK: - Shared Accessibility Modifiers

extension View {

    /// Igual que `.animation(_:value:)`, pero se desactiva si el usuario
    /// tiene activado "Reducir movimiento".
    func motionSafeAnimation<Value: Equatable>(
        _ animation: Animation,
        value: Value
    ) -> some View {
        modifier(MotionSafeAnimation(animation: animation, value: value))
    }

    /// Encabezado de una pestaña: VoiceOver lo lee como un solo elemento
    /// (título + descripción) y lo anuncia como encabezado.
    func converterHeaderAccessibility() -> some View {
        accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isHeader)
    }

    /// Selector de modo (por ejemplo "Texto → Morse" / "Morse → Texto").
    func converterModePickerAccessibility() -> some View {
        accessibilityLabel("Modo de conversión")
            .accessibilityHint(
                "Elige si conviertes de texto al código o del código a texto"
            )
    }

    /// Campo de texto de entrada. El título visible está en otra vista,
    /// así que se le da al campo para que VoiceOver sepa qué es.
    func converterInputAccessibility(title: LocalizedStringKey) -> some View {
        accessibilityLabel(title)
            .accessibilityHint(
                "Escribe o pega aquí el contenido que quieres convertir. El resultado se actualiza al instante."
            )
    }

    /// Botón "Copiar resultado".
    func converterCopyButtonAccessibility() -> some View {
        accessibilityHint("Copia el resultado al portapapeles")
    }

    /// Botón "Limpiar".
    func converterClearButtonAccessibility() -> some View {
        accessibilityHint("Borra el texto de entrada y el resultado")
    }
}
