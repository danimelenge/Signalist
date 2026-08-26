//
//  AsciiViewModel.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 24/08/26.
//

import Foundation
import Combine
import AppKit

/// ViewModel encargado de gestionar la conversión entre texto y código ASCII.
///
/// Utiliza Combine para actualizar automáticamente el resultado
/// mientras el usuario escribe o cambia el modo de conversión.
@MainActor
final class AsciiViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Texto introducido por el usuario.
    @Published var inputText: String = ""

    /// Modo actual de conversión.
    ///
    /// Permite convertir de texto a ASCII o de ASCII a texto.
    @Published var mode: AsciiConversionMode = .textToAscii

    /// Resultado de la conversión actual.
    ///
    /// Es de solo lectura desde fuera del ViewModel para evitar
    /// modificaciones directas del resultado.
    @Published private(set) var outputText: String = ""

    // MARK: - Private Properties

    /// Conjunto de suscripciones utilizadas por Combine.
    ///
    /// Las suscripciones se mantienen activas mientras exista
    /// el ViewModel y se cancelan automáticamente al liberarse.
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /// Inicializa el ViewModel y configura las vinculaciones
    /// necesarias para realizar las conversiones automáticamente.
    init() {
        setupBindings()
    }

    // MARK: - Bindings

    /// Configura las suscripciones que reaccionan a los cambios
    /// del texto de entrada y del modo de conversión.
    ///
    /// Se utiliza un pequeño `debounce` para evitar realizar
    /// conversiones innecesarias mientras el usuario está escribiendo.
    private func setupBindings() {
        Publishers.CombineLatest($inputText, $mode)
            .debounce(
                for: .milliseconds(150),
                scheduler: RunLoop.main
            )
            .map { text, mode -> String in

                switch mode {

                case .textToAscii:
                    return AsciiCode.encode(text)

                case .asciiToText:
                    return AsciiCode.decode(text)
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
    /// Si no existe ningún resultado, la operación se ignora.
    func copyOutputToClipboard() {
        guard !outputText.isEmpty else { return }

        let pasteboard = NSPasteboard.general

        pasteboard.clearContents()
        pasteboard.setString(
            outputText,
            forType: .string
        )
    }

    // MARK: - Actions

    /// Limpia el texto introducido por el usuario.
    ///
    /// Al modificar `inputText`, la vinculación de Combine
    /// actualizará automáticamente `outputText`.
    func clearAll() {
        inputText = ""
    }

    // MARK: - TODO

    // TODO: Agregar validación específica para entradas ASCII
    //       cuando el usuario utilice el modo ASCII → Texto.

    // MARK: - FIXME

    // FIXME: Revisar el comportamiento de caracteres que no formen
    //        parte del rango ASCII estándar.

    // MARK: - NOTE

    // NOTE: La conversión se realiza automáticamente mediante Combine
    //       después de 150 ms sin cambios en la entrada.

    // NOTE: `@MainActor` garantiza que las actualizaciones publicadas
    //       que afectan a la interfaz se realicen en el contexto principal.
}
