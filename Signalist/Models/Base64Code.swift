//
//  Base64Code.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 3/09/26.
//

import Foundation

// MARK: - Base64 Code

/// Convierte texto a Base64 y viceversa.
struct Base64Code {

    // MARK: - Encode (Texto → Base64)

    /// Convierte texto a su representación en Base64, usando UTF-8
    /// como codificación intermedia.
    static func encode(_ text: String) -> String {
        guard let data = text.data(using: .utf8) else { return "" }
        return data.base64EncodedString()
    }

    // MARK: - Decode (Base64 → Texto)

    /// Convierte una cadena Base64 de vuelta a texto legible.
    /// Devuelve una cadena vacía si el Base64 es inválido o no
    /// representa texto UTF-8 válido.
    static func decode(_ base64: String) -> String {
        let cleaned = base64.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let data = Data(base64Encoded: cleaned, options: .ignoreUnknownCharacters),
              let text = String(data: data, encoding: .utf8)
        else { return "" }

        return text
    }

    // MARK: - FIXME

    // FIXME: `decode` devuelve una cadena vacía tanto si el Base64 es
    // inválido como si simplemente el usuario no ha escrito nada.
    // Considerar distinguir ambos casos (ej. con un Result o un mensaje
    // de error visible) para que el usuario sepa por qué no obtuvo resultado.
}

// MARK: - Conversion Mode

enum Base64ConversionMode: String, CaseIterable, Identifiable {
    case textToBase64 = "Texto → Base64"
    case base64ToText = "Base64 → Texto"
    var id: String { rawValue }
}
