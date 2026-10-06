//
//  OghamCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 6/10/26.
//

import Foundation

// MARK: - Ogham Code

/// Convierte texto al alfabeto Ogham (el antiguo alfabeto irlandés,
/// usado aprox. entre los siglos IV y X) y viceversa, usando el
/// bloque Unicode "Ogham" (U+1680–U+169C).
struct OghamCode {

    // MARK: - Letter Dictionary (a–z)

    /// Cada letra se asocia a su trazo Ogham correspondiente. El Ogham
    /// original tiene 20 letras (más algunos "forfeda" adicionales), así
    /// que C/K, F/V, U/W, I/J/Y y X/Z se aproximan a la letra de sonido
    /// más cercano, siguiendo la convención habitual en traductores Ogham.
    static let letterDictionary: [Character: Character] = [
        "a": "\u{1690}", // ailm
        "b": "\u{1681}", // beith
        "c": "\u{1689}", // coll
        "d": "\u{1687}", // dair
        "e": "\u{1693}", // edad
        "f": "\u{1683}", // fearn
        "g": "\u{168C}", // gort
        "h": "\u{1686}", // uath
        "i": "\u{1694}", // idad
        "j": "\u{1694}", // idad (aproximado, como "i")
        "k": "\u{1689}", // coll (aproximado, como "c")
        "l": "\u{1682}", // luis
        "m": "\u{168B}", // muin
        "n": "\u{1685}", // nion
        "o": "\u{1691}", // onn
        "p": "\u{169A}", // peith (forfeda)
        "q": "\u{168A}", // ceirt
        "r": "\u{168F}", // ruis
        "s": "\u{1684}", // sail
        "t": "\u{1688}", // tinne
        "u": "\u{1692}", // úr
        "v": "\u{1683}", // fearn (aproximado, como "f")
        "w": "\u{1692}", // úr (aproximado, como "u")
        "x": "\u{168E}", // straif (aproximado, como "z/x")
        "y": "\u{1694}", // idad (aproximado, como "i")
        "z": "\u{168E}"  // straif
    ]

    /// Marca de espacio Ogham tradicional, usada entre palabras en
    /// inscripciones reales.
    private static let wordDivider: Character = "\u{1680}" // ogham space mark

    // MARK: - Reverse Dictionary

    private static let reverseDictionary: [Character: Character] = {
        Dictionary(uniqueKeysWithValues: letterDictionary.map { ($1, $0) })
    }()

    // MARK: - Encode (Texto → Ogham)

    /// Convierte cada letra a su trazo Ogham. Al igual que las runas,
    /// las letras no llevan espacio entre sí; las palabras se separan
    /// con la marca de espacio Ogham tradicional.
    static func encode(_ text: String) -> String {
        var result = ""

        for character in text.lowercased() {
            if character == " " {
                result.append(wordDivider)
                continue
            }

            if let ogham = letterDictionary[character] {
                result.append(ogham)
            }
            // caracter no soportado (números, acentos): se omite
        }

        return result
    }

    // MARK: - Decode (Ogham → Texto)

    static func decode(_ ogham: String) -> String {
        var result = ""

        for character in ogham {
            if character == wordDivider || character == " " {
                result.append(" ")
                continue
            }

            if let letter = reverseDictionary[character] {
                result.append(letter)
            }
            // símbolo no reconocido: se omite
        }

        return result
    }

    // MARK: - NOTE

    // NOTE: Al igual que Runas, esta pestaña usa una transliteración
    // real y reconocida del alfabeto Ogham (no un cifrado inventado por
    // Signalist). Las letras C/K, F/V, U/W, I/J/Y y X/Z se aproximan por
    // sonido, ya que el Ogham original solo tiene 20 letras (más algunos
    // "forfeda" adicionales usados aquí para P).
}

// MARK: - Conversion Mode

enum OghamConversionMode: String, CaseIterable, Identifiable {
    case textToOgham = "Texto → Ogham"
    case oghamToText = "Ogham → Texto"
    var id: String { rawValue }
}
