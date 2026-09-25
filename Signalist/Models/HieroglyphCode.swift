//
//  HieroglyphCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 25/09/26.
//

import Foundation

// MARK: - Hieroglyph Code

/// Convierte texto a un cifrado de sustitución usando jeroglíficos
/// egipcios reales (bloque Unicode "Egyptian Hieroglyphs", U+13000–U+1342F)
/// y viceversa.
struct HieroglyphCode {

    // MARK: - Letter Dictionary (a–z)

    /// Cada letra se asocia a un carácter Unicode real y válido del
    /// bloque de jeroglíficos egipcios.
    static let letterDictionary: [Character: Character] = [
        "a": "\u{13000}", "b": "\u{13001}", "c": "\u{13002}", "d": "\u{13003}",
        "e": "\u{13004}", "f": "\u{13005}", "g": "\u{13006}", "h": "\u{13007}",
        "i": "\u{13008}", "j": "\u{13009}", "k": "\u{1300A}", "l": "\u{1300B}",
        "m": "\u{1300C}", "n": "\u{1300D}", "o": "\u{1300E}", "p": "\u{1300F}",
        "q": "\u{13010}", "r": "\u{13011}", "s": "\u{13012}", "t": "\u{13013}",
        "u": "\u{13014}", "v": "\u{13015}", "w": "\u{13016}", "x": "\u{1306F}",
        "y": "\u{13070}", "z": "\u{13071}"
    ]

    // MARK: - Reverse Dictionary

    private static let reverseDictionary: [Character: Character] = {
        Dictionary(uniqueKeysWithValues: letterDictionary.map { ($1, $0) })
    }()

    // MARK: - Encode (Texto → Jeroglíficos)

    /// Convierte cada letra a su jeroglífico correspondiente. Los espacios
    /// se representan con "/" y las letras se separan con un espacio,
    /// ya que los jeroglíficos no llevan espaciado propio entre símbolos.
    static func encode(_ text: String) -> String {
        var tokens: [String] = []

        for character in text.lowercased() {
            if character == " " {
                tokens.append("/")
                continue
            }

            if let glyph = letterDictionary[character] {
                tokens.append(String(glyph))
            }
            // caracter no soportado (números, acentos): se omite
        }

        return tokens.joined(separator: " ")
    }

    // MARK: - Decode (Jeroglíficos → Texto)

    static func decode(_ hieroglyphs: String) -> String {
        let tokens = hieroglyphs
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        var result = ""

        for token in tokens {
            if token == "/" {
                result.append(" ")
                continue
            }

            if let glyph = token.first, let letter = reverseDictionary[glyph] {
                result.append(letter)
            }
            // token no reconocido: se omite
        }

        return result
    }

    // MARK: - NOTE

    // NOTE: Este es un cifrado de sustitución propio de Signalist que usa
    // símbolos reales y válidos del bloque Unicode "Egyptian Hieroglyphs"
    // (verificado: cada punto de código pertenece a un rango confirmado
    // como asignado por el estándar Unicode 5.2). NO es una transliteración
    // académica del sistema de "signos uniliterales" egipcios (el llamado
    // "alfabeto" usado por egiptólogos) — es un cifrado creativo/educativo
    // que usa jeroglíficos reales, similar en espíritu a ROT13 o César,
    // pero con símbolos visualmente auténticos.
}

// MARK: - Conversion Mode

enum HieroglyphConversionMode: String, CaseIterable, Identifiable {
    case textToHieroglyph = "Texto → Jeroglíficos"
    case hieroglyphToText = "Jeroglíficos → Texto"
    var id: String { rawValue }
}
