//
//  BinaryViewModel.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 19/08/26.
//

import Foundation
import Combine
import AppKit

// MARK: - Binary ViewModel

/// ViewModel encargado de gestionar la conversión de texto ↔ código binario.
///
/// Utiliza Combine para observar los cambios realizados en el texto de entrada
/// y en el modo de conversión. La conversión se realiza automáticamente después
/// de un pequeño retraso para evitar cálculos innecesarios mientras el usuario escribe.
@MainActor
final class BinaryViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Texto introducido por el usuario.
    @Published var inputText: String = ""

    /// Modo actual de conversión:
    /// - Texto → Binario
    /// - Binario → Texto
    @Published var mode: BinaryConversionMode = .textToBinary

    /// Resultado generado por la conversión.
    ///
    /// `private(set)` evita que otras partes de la aplicación puedan modificar
    /// directamente el resultado.
    @Published private(set) var outputText: String = ""

    // MARK: - Private Properties

    /// Colección de suscripciones utilizadas por Combine.
    ///
    /// Mantiene activas las suscripciones mientras exista el ViewModel.
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /// Inicializa el ViewModel y configura las vinculaciones de Combine.
    init() {
        setupBindings()
    }

    // MARK: - Bindings

    /// Configura las suscripciones encargadas de actualizar automáticamente
    /// el resultado cuando cambia el texto o el modo de conversión.
    ///
    /// Se utiliza `debounce` para esperar 150 ms después del último cambio
    /// antes de ejecutar la conversión.
    private func setupBindings() {
        Publishers.CombineLatest($inputText, $mode)
            .debounce(
                for: .milliseconds(150),
                scheduler: RunLoop.main
            )
            .map { text, mode -> String in

                switch mode {

                // Convierte texto normal a código binario.
                case .textToBinary:
                    return BinaryCode.encode(text)

                // Convierte código binario a texto normal.
                case .binaryToText:
                    return BinaryCode.decode(text)
                }
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.outputText = result
            }
            .store(in: &cancellables)
    }

    // MARK: - Clipboard

    /// Copia el resultado actual al portapapeles de macOS.
    ///
    /// No realiza ninguna acción si el resultado está vacío.
    func copyOutputToClipboard() {
        guard !outputText.isEmpty else { return }

        let pasteboard = NSPasteboard.general

        pasteboard.clearContents()
        pasteboard.setString(
            outputText,
            forType: .string
        )
    }

    // MARK: - Reset

    /// Limpia el contenido introducido por el usuario.
    ///
    /// Al modificar `inputText`, la suscripción de Combine actualiza
    /// automáticamente `outputText`.
    func clearAll() {
        inputText = ""
    }

    // MARK: - TODO

    // TODO: Agregar validación visual para entradas binarias
    //       que contengan caracteres diferentes de 0 y 1.

    // MARK: - FIXME

    // FIXME: Revisar el comportamiento de BinaryCode.decode(_:) cuando
    //        recibe grupos binarios incompletos o mal formados.

    // MARK: - NOTE

    // NOTE: El ViewModel está marcado con @MainActor porque sus propiedades
    //       publicadas actualizan directamente la interfaz de SwiftUI.

    // NOTE: La conversión se ejecuta automáticamente mediante Combine,
    //       por lo que la vista no necesita llamar manualmente a una función
    //       de conversión.

    // NOTE: NSPasteboard se utiliza para integrar la función de copiar
    //       resultado con el portapapeles nativo de macOS.

    // MARK: - Memory Management

    // NOTE: [weak self] en la suscripción evita mantener una referencia fuerte
    //       al ViewModel desde el publisher y ayuda a prevenir ciclos de retención.
}
