//
//  NatoViewModel.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 3/08/26.
//

import Foundation
import Combine
import AppKit

/// ViewModel encargado de la lógica de conversión entre
/// texto y alfabeto fonético de la OTAN (NATO).
@MainActor
final class NatoViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Texto introducido por el usuario.
    @Published var inputText: String = ""

    /// Modo de conversión seleccionado.
    @Published var mode: NatoConversionMode = .textToNato

    /// Resultado de la conversión.
    @Published private(set) var outputText: String = ""

    // MARK: - Private Properties

    /// Almacena las suscripciones de Combine.
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /// Inicializa el ViewModel y configura los bindings.
    init() {
        setupBindings()
    }

    // MARK: - Bindings

    /// Observa cambios en el texto de entrada y el modo de conversión
    /// para actualizar automáticamente el resultado.
    private func setupBindings() {
        Publishers.CombineLatest($inputText, $mode)
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .map { text, mode -> String in
                switch mode {

                case .textToNato:
                    return NatoCode.encode(text)

                case .natoToText:
                    return NatoCode.decode(text)
                }
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.outputText = result
            }
            .store(in: &cancellables)
    }

    // MARK: - Clipboard

    /// Copia el resultado actual al portapapeles del sistema.
    func copyOutputToClipboard() {
        guard !outputText.isEmpty else { return }

        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(outputText, forType: .string)
    }

    // MARK: - Actions

    /// Limpia el texto de entrada.
    /// El resultado se actualiza automáticamente mediante los bindings.
    func clearAll() {
        inputText = ""
    }

    // MARK: - TODO

    // TODO: Agregar soporte para pronunciación mediante síntesis de voz.

    // MARK: - FIXME

    // FIXME: Implementar soporte para caracteres acentuados (á, é, í, ó, ú, ñ)
    // y símbolos especiales que aún no forman parte del diccionario NATO.

    // MARK: - NOTE

    // NOTE: El resultado se genera automáticamente utilizando Combine,
    // evitando la necesidad de botones para ejecutar la conversión.
}
