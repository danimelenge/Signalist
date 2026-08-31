//
//  UnicodeCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 31/08/26.
//

import Foundation

/// Convierte texto a sus puntos de código Unicode (formato U+XXXX) y viceversa.
struct UnicodeCode {

    // MARK: - Encode (Texto → Unicode)

    /// Convierte cada carácter (incluyendo emojis y símbolos compuestos)
    /// a su punto de código Unicode en formato "U+XXXX", separados por espacios.
    static func encode(_ text: String) -> String {
        text
            .unicodeScalars
            .map { scalar in
                let hex = String(scalar.value, radix: 16, uppercase: true)
                let padded = hex.count < 4
                    ? String(repeating: "0", count: 4 - hex.count) + hex
                    : hex
                return "U+\(padded)"
            }
            .joined(separator: " ")
    }

    // MARK: - Decode (Unicode → Texto)

    /// Convierte una cadena de puntos de código "U+XXXX" (separados por espacios)
    /// de vuelta a texto legible.
    static func decode(_ unicode: String) -> String {
        let tokens = unicode
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        var scalars: [Unicode.Scalar] = []

        for token in tokens {
            var hexString = token.uppercased()

            if hexString.hasPrefix("U+") {
                hexString.removeFirst(2)
            }

            guard let value = UInt32(hexString, radix: 16),
                  let scalar = Unicode.Scalar(value)
            else { continue }

            scalars.append(scalar)
        }

        var result = ""
        result.unicodeScalars.append(contentsOf: scalars)
        return result
    }
}

// MARK: - Conversion Mode

enum UnicodeConversionMode: String, CaseIterable, Identifiable {
    case textToUnicode = "Texto → Unicode"
    case unicodeToText = "Unicode → Texto"
    var id: String { rawValue }
}
