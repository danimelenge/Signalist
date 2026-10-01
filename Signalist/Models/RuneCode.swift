//
//  RuneCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 1/10/26.
//

import Foundation

// MARK: - Rune Code

/// Convierte texto al alfabeto rúnico Elder Futhark (el más antiguo de
/// los alfabetos rúnicos germánicos, usado aprox. entre los siglos II y
/// VIII) y viceversa, usando el bloque Unicode "Runic" (U+16A0–U+16FF).
struct RuneCode {

    // MARK: - Letter Dictionary (a–z)

    /// Cada letra se asocia a su runa Elder Futhark correspondiente.
    /// El inglés/español moderno tiene más letras que las 24 runas
    /// originales, así que C, Q, V, X y Y se aproximan a la runa con
    /// sonido más cercano (convención habitual en traductores rúnicos).
    static let letterDictionary: [Character: Character] = [
        "a": "\u{16A8}", // ansuz
        "b": "\u{16D2}", // berkanan
        "c": "\u{16B2}", // kauna (aproximado, como "k")
        "d": "\u{16DE}", // dagaz
        "e": "\u{16D6}", // ehwaz
        "f": "\u{16A0}", // fehu
        "g": "\u{16B7}", // gebo
        "h": "\u{16BA}", // haglaz
        "i": "\u{16C1}", // isaz
        "j": "\u{16C3}", // jeran
        "k": "\u{16B2}", // kauna
        "l": "\u{16DA}", // laukaz
        "m": "\u{16D7}", // mannaz
        "n": "\u{16BE}", // naudiz
        "o": "\u{16DF}", // othalan
        "p": "\u{16C8}", // pertho
        "q": "\u{16B2}", // kauna (aproximado, como "k")
        "r": "\u{16B1}", // raido
        "s": "\u{16CA}", // sowilo
        "t": "\u{16CF}", // tiwaz
        "u": "\u{16A2}", // uruz
        "v": "\u{16B9}", // wunjo (aproximado, como "w")
        "w": "\u{16B9}", // wunjo
        "x": "\u{16C9}", // algiz (aproximado, como "z")
        "y": "\u{16C3}", // jeran (aproximado, como "j")
        "z": "\u{16C9}"  // algiz
    ]

    /// Marca de puntuación rúnica usada entre palabras.
    private static let wordDivider: Character = "\u{16EB}" // runic single punctuation

    // MARK: - Reverse Dictionary

    private static let reverseDictionary: [Character: Character] = {
        Dictionary(uniqueKeysWithValues: letterDictionary.map { ($1, $0) })
    }()

    // MARK: - Encode (Texto → Runas)

    /// Convierte cada letra a su runa correspondiente. A diferencia de
    /// otros códigos de la app, aquí cada letra es un solo carácter
    /// rúnico sin espacio entre ellas (como en las inscripciones
    /// originales); las palabras se separan con la marca de puntuación
    /// rúnica tradicional en vez de un espacio latino.
    static func encode(_ text: String) -> String {
        var result = ""

        for character in text.lowercased() {
            if character == " " {
                result.append(wordDivider)
                continue
            }

            if let rune = letterDictionary[character] {
                result.append(rune)
            }
            // caracter no soportado (números, acentos): se omite
        }

        return result
    }

    // MARK: - Decode (Runas → Texto)

    static func decode(_ runes: String) -> String {
        var result = ""

        for character in runes {
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

    // NOTE: A diferencia de Cuneiforme y Jeroglíficos (cifrados creativos
    // propios de Signalist), esta pestaña usa una transliteración real y
    // ampliamente reconocida del alfabeto Elder Futhark, la misma
    // convención que usan la mayoría de los traductores de "nombre en
    // runas". Las letras C, Q, V, X, Y no existen en el Futhark original
    // (24 runas) y se aproximan por sonido, como es práctica común.
}

// MARK: - Conversion Mode

enum RuneConversionMode: String, CaseIterable, Identifiable {
    case textToRune = "Texto → Runas"
    case runeToText = "Runas → Texto"
    var id: String { rawValue }
}
