//
//  SemaphoreCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 23/09/26.
//

import Foundation

// MARK: - Semaphore Code

/// Convierte texto al alfabeto de banderas de semáforo naval y viceversa.
///
/// Cada letra se representa con la posición de ambos brazos (derecho e
/// izquierdo), usando 8 direcciones posibles separadas por 45°. La tabla
/// de posiciones sigue el estándar de banderas de semáforo documentado
/// por CEMC (University of Waterloo).
struct SemaphoreCode {

    // MARK: - Direction

    /// Las 8 direcciones posibles de un brazo, representadas con flechas.
    enum Direction: String, CaseIterable {
        case up = "↑"
        case down = "↓"
        case left = "←"
        case right = "→"
        case upLeft = "↖"
        case upRight = "↗"
        case downLeft = "↙"
        case downRight = "↘"
    }

    // MARK: - Letter Positions

    /// Posición de brazo derecho e izquierdo para cada letra (y el espacio).
    static let letterPositions: [Character: (right: Direction, left: Direction)] = [
        "a": (.downRight, .down),
        "b": (.right, .down),
        "c": (.upRight, .down),
        "d": (.up, .down),
        "e": (.down, .upLeft),
        "f": (.down, .left),
        "g": (.down, .downLeft),
        "h": (.right, .downRight),
        "i": (.downRight, .upRight),
        "j": (.up, .left),
        "k": (.downRight, .up),
        "l": (.downRight, .upLeft),
        "m": (.downRight, .left),
        "n": (.downRight, .downLeft),
        "o": (.right, .upRight),
        "p": (.right, .up),
        "q": (.right, .upLeft),
        "r": (.right, .left),
        "s": (.right, .downLeft),
        "t": (.upRight, .up),
        "u": (.upRight, .upLeft),
        "v": (.up, .downLeft),
        "w": (.upLeft, .left),
        "x": (.upLeft, .downLeft),
        "y": (.upRight, .left),
        "z": (.downLeft, .left),
        " ": (.down, .down)
    ]

    // MARK: - Reverse Positions

    private static let reversePositions: [String: Character] = {
        var dict: [String: Character] = [:]
        for (letter, positions) in letterPositions {
            let key = "\(positions.right.rawValue)\(positions.left.rawValue)"
            dict[key] = letter
        }
        return dict
    }()

    // MARK: - Encode (Texto → Semáforo)

    /// Convierte cada letra a un par de flechas (brazo derecho + izquierdo),
    /// separando letras con espacio y palabras con " / ".
    static func encode(_ text: String) -> String {
        var tokens: [String] = []

        for character in text.lowercased() {
            if character == " " {
                tokens.append("/")
                continue
            }

            if let positions = letterPositions[character] {
                tokens.append("\(positions.right.rawValue)\(positions.left.rawValue)")
            }
            // caracter no soportado (números, acentos): se omite
        }

        return tokens.joined(separator: " ")
    }

    // MARK: - Decode (Semáforo → Texto)

    /// Convierte una cadena de pares de flechas de vuelta a texto legible.
    static func decode(_ semaphore: String) -> String {
        let tokens = semaphore
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        var result = ""

        for token in tokens {
            if token == "/" {
                result.append(" ")
                continue
            }

            if let letter = reversePositions[token] {
                result.append(letter)
            }
            // token no reconocido: se omite
        }

        return result
    }

    // MARK: - NOTE

    // NOTE: Esta tabla de posiciones (brazo derecho, brazo izquierdo) está
    // basada en la documentación del "Problem of the Week" de CEMC
    // (University of Waterloo), que describe cada letra en términos de
    // posición vertical/horizontal/diagonal de ambos brazos.
}

// MARK: - Conversion Mode

enum SemaphoreConversionMode: String, CaseIterable, Identifiable {
    case textToSemaphore = "Texto → Semáforo"
    case semaphoreToText = "Semáforo → Texto"
    var id: String { rawValue }
}
