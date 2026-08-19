//
//  BinaryCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 19/08/26.
//

import Foundation

/// Convierte texto a binario (ASCII de 8 bits) y viceversa.
struct BinaryCode {

    // MARK: - Encode (Texto → Binario)

    /// Convierte cada carácter a su representación binaria de 8 bits (UTF-8),
    /// separando cada byte con un espacio.
    static func encode(_ text: String) -> String {
        text.utf8
            .map { byte in
                String(byte, radix: 2)
                    .leftPadded(to: 8, with: "0")
            }
            .joined(separator: " ")
    }

    // MARK: - Decode (Binario → Texto)

    /// Convierte una cadena de bytes binarios (separados por espacios)
    /// de vuelta a texto legible.
    static func decode(_ binary: String) -> String {
        let groups = binary
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        var bytes: [UInt8] = []

        for group in groups {
            // Solo procesa grupos válidos de 0s y 1s
            guard group.allSatisfy({ $0 == "0" || $0 == "1" }),
                  let value = UInt8(group, radix: 2)
            else { continue }

            bytes.append(value)
        }

        return String(decoding: bytes, as: UTF8.self)
    }
}

// MARK: - String Padding Helper

private extension String {
    /// Rellena la cadena por la izquierda hasta alcanzar la longitud indicada.
    func leftPadded(to length: Int, with character: Character) -> String {
        let padding = length - count
        guard padding > 0 else { return self }
        return String(repeating: character, count: padding) + self
    }
}

// MARK: - Conversion Mode

enum BinaryConversionMode: String, CaseIterable, Identifiable {
    case textToBinary = "Texto → Binario"
    case binaryToText = "Binario → Texto"
    var id: String { rawValue }
}
