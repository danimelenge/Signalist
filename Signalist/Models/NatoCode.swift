//
//  NatoCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 3/08/26.
//

import Foundation

/// Convierte texto a Alfabeto Fonético Internacional (NATO) y viceversa.
struct NatoCode {

    // MARK: - Letter dictionary (a–z)

    static let letterDictionary: [Character: String] = [
        "a": "Alfa", "b": "Bravo", "c": "Charlie", "d": "Delta", "e": "Echo",
        "f": "Foxtrot", "g": "Golf", "h": "Hotel", "i": "India", "j": "Juliett",
        "k": "Kilo", "l": "Lima", "m": "Mike", "n": "November", "o": "Oscar",
        "p": "Papa", "q": "Quebec", "r": "Romeo", "s": "Sierra", "t": "Tango",
        "u": "Uniform", "v": "Victor", "w": "Whiskey", "x": "X-ray", "y": "Yankee",
        "z": "Zulu"
    ]

    // MARK: - Digit dictionary (0–9)

    static let digitDictionary: [Character: String] = [
        "0": "Zero", "1": "One", "2": "Two", "3": "Three", "4": "Four",
        "5": "Five", "6": "Six", "7": "Seven", "8": "Eight", "9": "Nine"
    ]

    // MARK: - Reverse dictionaries

    /// Mapea la palabra en minúsculas (ej. "alfa") a su letra o dígito original.
    private static let reverseDictionary: [String: Character] = {
        var dict: [String: Character] = [:]
        for (letter, word) in letterDictionary {
            dict[word.lowercased()] = letter
        }
        for (digit, word) in digitDictionary {
            dict[word.lowercased()] = digit
        }
        return dict
    }()

    // MARK: - Encode (Texto → NATO)

    static func encode(_ text: String) -> String {
        var words: [String] = []

        for character in text.lowercased() {
            if character == " " {
                words.append("/")
                continue
            }

            if let word = letterDictionary[character] {
                words.append(word)
                continue
            }

            if let word = digitDictionary[character] {
                words.append(word)
                continue
            }

            // Caracter no soportado: se omite
        }

        return words.joined(separator: " ")
    }

    // MARK: - Decode (NATO → Texto)

    static func decode(_ nato: String) -> String {
        let tokens = nato
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: .whitespaces) }

        var result = ""

        for token in tokens {
            if token == "/" {
                result.append(" ")
                continue
            }

            if let character = reverseDictionary[token.lowercased()] {
                result.append(character)
                continue
            }

            // Palabra no reconocida: se omite
        }

        return result
    }
}

// MARK: - Conversion Mode

enum NatoConversionMode: String, CaseIterable, Identifiable {
    case textToNato = "Texto → NATO"
    case natoToText = "NATO → Texto"
    var id: String { rawValue }
}
