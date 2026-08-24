//
//  AsciiCode.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 24/08/26.
//

import Foundation

/// Convierte texto a códigos ASCII decimales y viceversa.
struct AsciiCode {

    // MARK: - Encode (Texto → ASCII)

    /// Convierte cada carácter a su código ASCII/UTF-8 decimal,
    /// separando cada valor con un espacio.
    static func encode(_ text: String) -> String {
        text.utf8
            .map { String($0) }
            .joined(separator: " ")
    }

    // MARK: - Decode (ASCII → Texto)

    /// Convierte una cadena de códigos decimales (separados por espacios)
    /// de vuelta a texto legible.
    static func decode(_ ascii: String) -> String {
        let groups = ascii
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        var bytes: [UInt8] = []

        for group in groups {
            // Solo procesa números válidos en el rango de un byte (0-255)
            guard let value = UInt16(group), value <= 255 else { continue }
            bytes.append(UInt8(value))
        }

        return String(decoding: bytes, as: UTF8.self)
    }
}

// MARK: - Conversion Mode

enum AsciiConversionMode: String, CaseIterable, Identifiable {
    case textToAscii = "Texto → ASCII"
    case asciiToText = "ASCII → Texto"
    var id: String { rawValue }
}
