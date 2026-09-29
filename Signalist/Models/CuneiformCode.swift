//
//  CuneiformCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 29/09/26.
//

import Foundation

// MARK: - Cuneiform Code

/// Convierte texto a un cifrado de sustitución usando signos cuneiformes
/// sumerio-acadios reales (bloque Unicode "Cuneiform", U+12000–U+123FF)
/// y viceversa.
struct CuneiformCode {

    // MARK: - Letter Dictionary (a–z)

    /// Cada letra se asocia a un carácter Unicode real y válido del
    /// bloque de escritura cuneiforme (confirmado como asignado en el
    /// rango inicial del bloque, ej. U+12000 "CUNEIFORM SIGN A").
    static let letterDictionary: [Character: Character] = [
        "a": "\u{12000}", "b": "\u{12001}", "c": "\u{12002}", "d": "\u{12003}",
        "e": "\u{12004}", "f": "\u{12005}", "g": "\u{12006}", "h": "\u{12007}",
        "i": "\u{12008}", "j": "\u{12009}", "k": "\u{1200A}", "l": "\u{1200B}",
        "m": "\u{1200C}", "n": "\u{1200D}", "o": "\u{1200E}", "p": "\u{1200F}",
        "q": "\u{12010}", "r": "\u{12011}", "s": "\u{12012}", "t": "\u{12013}",
        "u": "\u{12014}", "v": "\u{12015}", "w": "\u{12016}", "x": "\u{12017}",
        "y": "\u{12018}", "z": "\u{12019}"
    ]

    // MARK: - Reverse Dictionary

    private static let reverseDictionary: [Character: Character] = {
        Dictionary(uniqueKeysWithValues: letterDictionary.map { ($1, $0) })
    }()

    // MARK: - Encode (Texto → Cuneiforme)

    /// Convierte cada letra a su signo cuneiforme correspondiente. Los
    /// espacios se representan con "/" y las letras se separan con un
    /// espacio, ya que los signos cuneiformes no llevan espaciado propio.
    static func encode(_ text: String) -> String {
        var tokens: [String] = []

        for character in text.lowercased() {
            if character == " " {
                tokens.append("/")
                continue
            }

            if let sign = letterDictionary[character] {
                tokens.append(String(sign))
            }
            // caracter no soportado (números, acentos): se omite
        }

        return tokens.joined(separator: " ")
    }

    // MARK: - Decode (Cuneiforme → Texto)

    static func decode(_ cuneiform: String) -> String {
        let tokens = cuneiform
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        var result = ""

        for token in tokens {
            if token == "/" {
                result.append(" ")
                continue
            }

            if let sign = token.first, let letter = reverseDictionary[sign] {
                result.append(letter)
            }
            // token no reconocido: se omite
        }

        return result
    }

    // MARK: - NOTE

    // NOTE: Este es un cifrado de sustitución propio de Signalist que usa
    // signos reales y válidos del bloque Unicode "Cuneiform" (verificado:
    // U+12000-U+1200A confirmados como asignados por el estándar Unicode
    // 5.0). NO es una transliteración académica del sumerio o acadio
    // antiguos — es un cifrado creativo/educativo que usa signos
    // cuneiformes auténticos, en el mismo espíritu que la pestaña de
    // Jeroglíficos.
}

// MARK: - Conversion Mode

enum CuneiformConversionMode: String, CaseIterable, Identifiable {
    case textToCuneiform = "Texto → Cuneiforme"
    case cuneiformToText = "Cuneiforme → Texto"
    var id: String { rawValue }
}
