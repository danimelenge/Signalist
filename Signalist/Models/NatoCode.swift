//
//  NatoCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 3/08/26.
//

import Foundation

/// Conversor del Alfabeto Fonético Internacional (NATO).
///
/// Proporciona métodos para convertir texto convencional
/// al alfabeto fonético NATO y realizar la conversión inversa.
///
/// También permite representar los números del 0 al 9
/// mediante sus correspondientes palabras en inglés.
struct NatoCode {

    // MARK: - Letter Dictionary

    /// Diccionario principal de letras.
    ///
    /// Cada letra del alfabeto se relaciona con su palabra
    /// correspondiente dentro del alfabeto fonético NATO.
    ///
    /// Ejemplo:
    /// - `A` → `Alfa`
    /// - `B` → `Bravo`
    /// - `C` → `Charlie`
    static let letterDictionary: [Character: String] = [
        "a": "Alfa",
        "b": "Bravo",
        "c": "Charlie",
        "d": "Delta",
        "e": "Echo",
        "f": "Foxtrot",
        "g": "Golf",
        "h": "Hotel",
        "i": "India",
        "j": "Juliett",
        "k": "Kilo",
        "l": "Lima",
        "m": "Mike",
        "n": "November",
        "o": "Oscar",
        "p": "Papa",
        "q": "Quebec",
        "r": "Romeo",
        "s": "Sierra",
        "t": "Tango",
        "u": "Uniform",
        "v": "Victor",
        "w": "Whiskey",
        "x": "X-ray",
        "y": "Yankee",
        "z": "Zulu"
    ]

    // MARK: - Digit Dictionary

    /// Diccionario de números.
    ///
    /// Contiene la representación NATO de los dígitos
    /// comprendidos entre 0 y 9.
    ///
    /// Ejemplo:
    /// - `0` → `Zero`
    /// - `1` → `One`
    /// - `9` → `Nine`
    static let digitDictionary: [Character: String] = [
        "0": "Zero",
        "1": "One",
        "2": "Two",
        "3": "Three",
        "4": "Four",
        "5": "Five",
        "6": "Six",
        "7": "Seven",
        "8": "Eight",
        "9": "Nine"
    ]

    // MARK: - Reverse Dictionaries

    /// Diccionario inverso utilizado durante la decodificación.
    ///
    /// Convierte las palabras NATO nuevamente en su
    /// correspondiente letra o número.
    ///
    /// Las claves se almacenan en minúsculas para permitir
    /// que la decodificación no dependa de las mayúsculas
    /// utilizadas en la entrada.
    ///
    /// Ejemplo:
    /// `alfa` → `a`
    /// `bravo` → `b`
    /// `one` → `1`
    private static let reverseDictionary: [String: Character] = {
        var dict: [String: Character] = [:]

        // MARK: Letters

        for (letter, word) in letterDictionary {
            dict[word.lowercased()] = letter
        }

        // MARK: Digits

        for (digit, word) in digitDictionary {
            dict[word.lowercased()] = digit
        }

        return dict
    }()

    // MARK: - Encode

    /// Convierte texto convencional al alfabeto fonético NATO.
    ///
    /// - Parameter text: Texto que se desea convertir.
    /// - Returns: Cadena con las palabras correspondientes
    ///   del alfabeto NATO separadas por espacios.
    ///
    /// Los espacios entre palabras se representan mediante `/`.
    ///
    /// Los caracteres que no están contemplados en los diccionarios
    /// se omiten.
    static func encode(_ text: String) -> String {
        var words: [String] = []

        // Recorre cada carácter utilizando una versión
        // normalizada en minúsculas.
        for character in text.lowercased() {

            // MARK: Space Handling

            // Los espacios se representan con "/"
            // para conservar la separación entre palabras.
            if character == " " {
                words.append("/")
                continue
            }

            // MARK: Letter Conversion

            // Busca el carácter dentro del diccionario de letras.
            if let word = letterDictionary[character] {
                words.append(word)
                continue
            }

            // MARK: Digit Conversion

            // Busca el carácter dentro del diccionario de números.
            if let word = digitDictionary[character] {
                words.append(word)
                continue
            }

            // MARK: Unsupported Character

            // Los caracteres que no cuentan con una representación
            // NATO son omitidos.
        }

        return words.joined(separator: " ")
    }

    // MARK: - Decode

    /// Convierte una cadena del alfabeto NATO nuevamente a texto.
    ///
    /// - Parameter nato: Texto codificado utilizando palabras NATO.
    /// - Returns: Texto convencional resultante de la conversión.
    ///
    /// Las palabras se separan mediante espacios y `/`
    /// representa la separación entre palabras originales.
    static func decode(_ nato: String) -> String {

        // Divide la entrada en tokens utilizando los espacios
        // como separadores.
        let tokens = nato
            .split(separator: " ")
            .map {
                $0.trimmingCharacters(in: .whitespaces)
            }

        var result = ""

        // MARK: Token Processing

        for token in tokens {

            // MARK: Word Separator

            // "/" representa un espacio entre palabras.
            if token == "/" {
                result.append(" ")
                continue
            }

            // MARK: NATO Conversion

            // Busca la palabra NATO en el diccionario inverso.
            if let character = reverseDictionary[token.lowercased()] {
                result.append(character)
                continue
            }

            // MARK: Unknown Token

            // Las palabras que no son reconocidas se omiten.
        }

        return result
    }

    // MARK: - TODO

    // TODO: Agregar soporte para caracteres especiales
    // y signos de puntuación que puedan complementar
    // el alfabeto fonético NATO.

    // MARK: - FIXME

    // FIXME: Revisar el manejo de múltiples espacios consecutivos
    // para conservar exactamente el formato original del texto.

    // FIXME: Evaluar el tratamiento de caracteres no soportados
    // para informar al usuario en lugar de omitirlos silenciosamente.

    // MARK: - NOTE

    // NOTE: Las palabras NATO se almacenan en inglés,
    // siguiendo la nomenclatura utilizada por el alfabeto
    // fonético internacional.

    // NOTE: La codificación convierte la entrada a minúsculas
    // antes de realizar las búsquedas en los diccionarios.

    // NOTE: El símbolo "/" se utiliza internamente para
    // representar espacios entre palabras durante la conversión.
}

// MARK: - Conversion Mode

/// Define los modos de conversión disponibles para la vista NATO.
///
/// Permite seleccionar entre convertir texto a NATO
/// o convertir NATO nuevamente a texto.
enum NatoConversionMode: String, CaseIterable, Identifiable {

    // MARK: - Cases

    /// Convierte texto convencional al alfabeto NATO.
    case textToNato = "Texto → NATO"

    /// Convierte palabras NATO nuevamente a texto.
    case natoToText = "NATO → Texto"

    // MARK: - Identifiable

    /// Identificador utilizado por SwiftUI para distinguir
    /// cada opción dentro de controles como Picker.
    var id: String {
        rawValue
    }
}

// MARK: - TODO

// TODO: Considerar agregar una descripción específica
// para cada modo de conversión que pueda mostrarse
// directamente en la interfaz de usuario.

// MARK: - NOTE

// NOTE: NatoConversionMode conforma a CaseIterable para
// permitir recorrer automáticamente todos los modos disponibles.

// NOTE: Identifiable permite utilizar este enum directamente
// en componentes SwiftUI como ForEach y Picker.
