//
//  Rot13Code.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 10/09/26.
//

import Foundation

// MARK: - ROT13 Code

/// Convierte texto usando ROT13, un caso especial del Cifrado César
/// con un desplazamiento fijo de 13 posiciones.
///
/// ROT13 es su propio inverso: aplicarlo dos veces sobre el mismo
/// texto devuelve el texto original. Por eso `encode` y `decode`
/// realizan exactamente la misma operación.
struct Rot13Code {

    // MARK: - Fixed Shift

    private static let shift = 13

    // MARK: - Encode (Texto → ROT13)

    static func encode(_ text: String) -> String {
        transform(text)
    }

    // MARK: - Decode (ROT13 → Texto)

    /// Idéntico a `encode`: ROT13 es simétrico.
    static func decode(_ text: String) -> String {
        transform(text)
    }

    // MARK: - Shared Transform

    /// Aplica el desplazamiento fijo de 13 a cada carácter alfabético,
    /// preservando mayúsculas/minúsculas y dejando intactos los demás
    /// caracteres.
    private static func transform(_ text: String) -> String {
        String(text.map { character -> Character in
            guard let asciiValue = character.asciiValue else {
                return character // no es ASCII: sin cambios
            }

            switch asciiValue {
            case 65...90: // A-Z
                let shifted = (Int(asciiValue) - 65 + shift) % 26 + 65
                return Character(UnicodeScalar(shifted)!)

            case 97...122: // a-z
                let shifted = (Int(asciiValue) - 97 + shift) % 26 + 97
                return Character(UnicodeScalar(shifted)!)

            default:
                return character // números, espacios, puntuación: sin cambios
            }
        })
    }

    // MARK: - NOTE

    // NOTE: A diferencia de CaesarCode, aquí no hay parámetro de
    // desplazamiento configurable — ROT13 es, por definición, siempre
    // un desplazamiento de 13. Esto también significa que la UI de
    // esta pestaña no necesita un Slider como la de César.
}

// MARK: - Conversion Mode

enum Rot13ConversionMode: String, CaseIterable, Identifiable {
    case textToRot13 = "Texto → ROT13"
    case rot13ToText = "ROT13 → Texto"
    var id: String { rawValue }
}
