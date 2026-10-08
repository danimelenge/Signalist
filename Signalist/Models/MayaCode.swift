//
//  MayaCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 8/10/26.
//

import Foundation

// MARK: - Maya Code

/// Convierte números decimales a numerales mayas (sistema posicional
/// de base 20) y viceversa, usando el bloque Unicode "Mayan Numerals"
/// (U+1D2E0–U+1D2F3, dígitos del 0 al 19).
struct MayaCode {

    // MARK: - Constants

    private static let zeroScalar: UInt32 = 0x1D2E0
    private static let nineteenScalar: UInt32 = 0x1D2F3
    private static let base: UInt64 = 20

    // MARK: - Encode (Número → Maya)

    /// Busca cada número entero en el texto (cualquier carácter que no
    /// sea un dígito actúa como separador) y lo convierte a numerales
    /// mayas. Los dígitos de un mismo número se separan con un espacio,
    /// del lugar más alto al más bajo, y los números se separan con " / ".
    static func encode(_ text: String) -> String {
        var numbers: [String] = []
        var currentRun = ""

        func flushRun() {
            guard !currentRun.isEmpty else { return }
            // UInt64(...) devuelve nil si el número es demasiado grande
            if let value = UInt64(currentRun) {
                numbers.append(mayaDigits(for: value))
            }
            currentRun = ""
        }

        for character in text {
            if character.isASCII && character.isNumber {
                currentRun.append(character)
            } else {
                flushRun()
            }
        }
        flushRun()

        return numbers.joined(separator: " / ")
    }

    // MARK: - Decode (Maya → Número)

    /// Convierte numerales mayas de vuelta a números decimales. Cada
    /// número se separa con "/", y dentro de cada número los espacios
    /// entre numerales son opcionales.
    static func decode(_ maya: String) -> String {
        var results: [String] = []

        for segment in maya.split(separator: "/") {
            var value: UInt64 = 0
            var foundDigit = false
            var overflowed = false

            for scalar in segment.unicodeScalars {
                guard scalar.value >= zeroScalar && scalar.value <= nineteenScalar else {
                    continue // espacios u otros caracteres: se ignoran
                }

                let digit = UInt64(scalar.value - zeroScalar)
                let (multiplied, overflow1) = value.multipliedReportingOverflow(by: base)
                let (sum, overflow2) = multiplied.addingReportingOverflow(digit)

                if overflow1 || overflow2 {
                    overflowed = true
                    break
                }

                value = sum
                foundDigit = true
            }

            if foundDigit && !overflowed {
                results.append(String(value))
            }
        }

        return results.joined(separator: ", ")
    }

    // MARK: - Digit Groups

    /// Extrae los dígitos (0–19) de cada número a partir de un texto
    /// ya codificado en numerales mayas. Se usa para dibujarlos en la UI.
    static func digitGroups(in encoded: String) -> [[Int]] {
        encoded
            .split(separator: "/")
            .map { segment in
                segment.unicodeScalars
                    .filter { $0.value >= zeroScalar && $0.value <= nineteenScalar }
                    .map { Int($0.value - zeroScalar) }
            }
            .filter { !$0.isEmpty }
    }

    // MARK: - Helpers

    /// Convierte un entero a sus dígitos en base 20, del más
    /// significativo al menos significativo, como glifos mayas.
    private static func mayaDigits(for value: UInt64) -> String {
        var digits: [UInt64] = []
        var remaining = value

        if remaining == 0 {
            digits = [0]
        }

        while remaining > 0 {
            digits.append(remaining % base)
            remaining /= base
        }

        return digits
            .reversed()
            .compactMap { Unicode.Scalar(zeroScalar + UInt32($0)) }
            .map { String($0) }
            .joined(separator: " ")
    }

    // MARK: - NOTE

    // NOTE: Esta pestaña convierte solo números porque la escritura
    // jeroglífica maya (sílabas y logogramas) aún no está codificada en
    // Unicode. Los numerales mayas sí lo están (bloque "Mayan Numerals"),
    // por eso esta es una conversión real y no un cifrado inventado.
    // Tradicionalmente los numerales se apilan en vertical (el lugar más
    // alto arriba); en la UI se dibujan así, y en el texto copiado se
    // escriben en horizontal para que quepan en una línea.

    // FIXME: Los números mayores a UInt64.max (≈ 1.8 × 10^19) se omiten
    // silenciosamente. Considerar mostrar un aviso visible al usuario.
}

// MARK: - Conversion Mode

enum MayaConversionMode: String, CaseIterable, Identifiable {
    case textToMaya = "Número → Maya"
    case mayaToText = "Maya → Número"
    var id: String { rawValue }
}
