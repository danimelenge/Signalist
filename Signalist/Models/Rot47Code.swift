//
//  Rot47Code.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 18/09/26.
//


import Foundation

// MARK: - ROT47 Code

/// Convierte texto usando ROT47, una variante de ROT13 que opera
/// sobre el rango ASCII imprimible (33-126), rotando 47 posiciones.
///
/// A diferencia de ROT13 (solo letras), ROT47 también transforma
/// números, signos de puntuación y símbolos. Es su propio inverso:
/// aplicarlo dos veces devuelve el texto original.
struct Rot47Code {

    // MARK: - ASCII Range

    private static let rangeStart = 33   // "!"
    private static let rangeEnd = 126    // "~"
    private static let rangeSize = rangeEnd - rangeStart + 1 // 94
    private static let shift = 47

    // MARK: - Encode (Texto → ROT47)

    static func encode(_ text: String) -> String {
        transform(text)
    }

    // MARK: - Decode (ROT47 → Texto)

    /// Idéntico a `encode`: ROT47 es simétrico, igual que ROT13.
    static func decode(_ text: String) -> String {
        transform(text)
    }

    // MARK: - Shared Transform

    /// Rota cada carácter imprimible ASCII (33-126) 47 posiciones
    /// dentro de ese mismo rango. Caracteres fuera del rango (espacios,
    /// saltos de línea, acentos, emojis) se dejan intactos.
    private static func transform(_ text: String) -> String {
        String(text.map { character -> Character in
            guard let asciiValue = character.asciiValue,
                  asciiValue >= rangeStart && asciiValue <= rangeEnd
            else {
                return character // fuera del rango imprimible: sin cambios
            }

            let offset = Int(asciiValue) - rangeStart
            let shifted = (offset + shift) % rangeSize + rangeStart
            return Character(UnicodeScalar(shifted)!)
        })
    }

    // MARK: - NOTE

    // NOTE: El espacio (código 32) queda justo fuera del rango 33-126,
    // por lo que nunca se transforma — esto preserva la separación de
    // palabras en el resultado, igual que ocurre naturalmente con ROT13.
}

// MARK: - Conversion Mode

enum Rot47ConversionMode: String, CaseIterable, Identifiable {
    case textToRot47 = "Texto → ROT47"
    case rot47ToText = "ROT47 → Texto"
    var id: String { rawValue }
}
