//
//  MorseCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 09/07/26.
//

import Foundation

// MARK: - Conversion Mode

/// Define el sentido de la conversión disponible en la aplicación.
enum ConversionMode: String, CaseIterable, Identifiable {

    /// Convierte texto plano a código Morse.
    case textToMorse = "Texto → Morse"

    /// Convierte código Morse a texto plano.
    case morseToText = "Morse → Texto"

    var id: String {
        rawValue
    }
}

// MARK: - Morse Code

/// Encargado de codificar y decodificar texto utilizando el alfabeto
/// internacional de código Morse.
struct MorseCode {

    // MARK: - Morse Dictionary

    /// Diccionario principal utilizado para convertir caracteres a Morse.
    static let dictionary: [Character: String] = [
        "a": ".-", "b": "-...", "c": "-.-.", "d": "-..", "e": ".",
        "f": "..-.", "g": "--.", "h": "....", "i": "..", "j": ".---",
        "k": "-.-", "l": ".-..", "m": "--", "n": "-.", "o": "---",
        "p": ".--.", "q": "--.-", "r": ".-.", "s": "...", "t": "-",
        "u": "..-", "v": "...-", "w": ".--", "x": "-..-", "y": "-.--",
        "z": "--..",

        "0": "-----", "1": ".----", "2": "..---", "3": "...--",
        "4": "....-", "5": ".....", "6": "-....", "7": "--...",
        "8": "---..", "9": "----.",

        ".": ".-.-.-",
        ",": "--..--",
        "?": "..--..",
        "'": ".----.",
        "!": "-.-.--",
        "/": "-..-.",
        "(": "-.--.",
        ")": "-.--.-",
        "&": ".-...",
        ":": "---...",
        ";": "-.-.-.",
        "=": "-...-",
        "+": ".-.-.",
        "-": "-....-",
        "_": "..--.-",
        "\"": ".-..-.",
        "$": "...-..-",
        "@": ".--.-."
    ]

    // MARK: - Reverse Dictionary

    /// Diccionario generado automáticamente para convertir
    /// código Morse nuevamente a texto.
    static let reverseDictionary: [String: Character] = {
        var dict: [String: Character] = [:]

        for (key, value) in dictionary {
            dict[value] = key
        }

        return dict
    }()

    // MARK: - Encode

    /// Convierte texto plano en código Morse.
    ///
    /// - Parameter text: Texto de entrada.
    /// - Returns: Cadena codificada en Morse.
    static func encode(_ text: String) -> String {

        let lowercased = text.lowercased()
        var result: [String] = []

        for character in lowercased {

            if character == " " {
                result.append("/")

            } else if let morse = dictionary[character] {
                result.append(morse)
            }
        }

        return result.joined(separator: " ")
    }

    // MARK: - Decode

    /// Convierte código Morse en texto plano.
    ///
    /// - Parameter morse: Código Morse separado por espacios.
    /// - Returns: Texto decodificado.
    static func decode(_ morse: String) -> String {

        let words = morse.components(separatedBy: " / ")
        var result: [String] = []

        for word in words {

            let letters = word.split(separator: " ")
            var decodedWord = ""

            for letter in letters {

                if let character = reverseDictionary[String(letter)] {
                    decodedWord.append(character)
                }
            }

            result.append(decodedWord)
        }

        return result.joined(separator: " ")
    }

    // MARK: - TODO

    // TODO: Agregar soporte para caracteres acentuados (á, é, í, ó, ú, ü, ñ).

    // TODO: Agregar soporte para símbolos adicionales del estándar ITU.

    // MARK: - FIXME

    // FIXME: Los caracteres no soportados actualmente se ignoran silenciosamente.
    // Considerar mostrar un marcador o advertencia para el usuario.

    // MARK: - NOTE

    // NOTE: Las palabras en Morse se separan mediante " / " y las letras
    // mediante un espacio, siguiendo la convención utilizada en Signalist.
}
