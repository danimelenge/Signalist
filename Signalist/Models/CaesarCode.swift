//
//  CaesarCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 8/09/26.
//

import Foundation

// MARK: - Caesar Code

/// Convierte texto usando el Cifrado César, un cifrado de sustitución
/// que desplaza cada letra un número fijo de posiciones en el alfabeto.
struct CaesarCode {

    // MARK: - Encode (Texto → Cifrado)

    /// Desplaza cada letra `shift` posiciones hacia adelante en el alfabeto.
    /// Los números, espacios y signos de puntuación no se modifican.
    static func encode(_ text: String, shift: Int) -> String {
        transform(text, by: shift)
    }

    // MARK: - Decode (Cifrado → Texto)

    /// Revierte el cifrado desplazando cada letra `shift` posiciones
    /// hacia atrás (equivalente a cifrar con el desplazamiento negativo).
    static func decode(_ text: String, shift: Int) -> String {
        transform(text, by: -shift)
    }

    // MARK: - Shared Transform

    /// Aplica el desplazamiento a cada carácter alfabético, preservando
    /// mayúsculas/minúsculas y dejando intactos los demás caracteres.
    private static func transform(_ text: String, by shift: Int) -> String {
        let normalizedShift = ((shift % 26) + 26) % 26 // siempre positivo, 0-25

        return String(text.map { character -> Character in
            guard let asciiValue = character.asciiValue else {
                return character // no es ASCII (ej. emojis, acentos): sin cambios
            }

            switch asciiValue {
            case 65...90: // A-Z
                let shifted = (Int(asciiValue) - 65 + normalizedShift) % 26 + 65
                return Character(UnicodeScalar(shifted)!)

            case 97...122: // a-z
                let shifted = (Int(asciiValue) - 97 + normalizedShift) % 26 + 97
                return Character(UnicodeScalar(shifted)!)

            default:
                return character // números, espacios, puntuación: sin cambios
            }
        })
    }

    // MARK: - NOTE

    // NOTE: Solo se cifran letras del alfabeto inglés (A-Z, a-z). Caracteres
    // con acentos (á, é, ñ, etc.) se dejan sin modificar, ya que no tienen
    // un valor ASCII de letra base consistente para desplazar.
}

// MARK: - Conversion Mode

enum CaesarConversionMode: String, CaseIterable, Identifiable {
    case textToCaesar = "Texto → César"
    case caesarToText = "César → Texto"
    var id: String { rawValue }
}
