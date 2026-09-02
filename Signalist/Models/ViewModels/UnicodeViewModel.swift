//
//  UnicodeViewModel.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 31/08/26.
//

import Foundation
import Combine
import AppKit

// MARK: - Unicode ViewModel

/// Maneja el estado y la lógica de conversión Texto ↔ Unicode.
/// Sigue el mismo patrón reactivo con Combine que MorseViewModel,
/// BrailleViewModel, NatoViewModel, BinaryViewModel y AsciiViewModel.
@MainActor
final class UnicodeViewModel: ObservableObject {

    // MARK: - Published Properties

    /// Texto o puntos de código Unicode escritos por el usuario.
    @Published var inputText: String = ""

    /// Dirección de la conversión actual (Texto → Unicode o Unicode → Texto).
    @Published var mode: UnicodeConversionMode = .textToUnicode

    /// Resultado calculado de la conversión. Solo se actualiza internamente.
    @Published private(set) var outputText: String = ""

    // MARK: - Combine

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        setupBindings()
    }

    // MARK: - Bindings

    /// Configura el pipeline reactivo: combina `inputText` y `mode`,
    /// aplica un debounce para no recalcular en cada pulsación, y
    /// convierte el resultado según el modo seleccionado.
    private func setupBindings() {
        Publishers.CombineLatest($inputText, $mode)
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .map { text, mode -> String in
                switch mode {
                case .textToUnicode:
                    return UnicodeCode.encode(text)
                case .unicodeToText:
                    return UnicodeCode.decode(text)
                }
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.outputText = result
            }
            .store(in: &cancellables)

        // TODO:
        // Si en el futuro se agrega historial de conversiones (como se
        // consideró para Morse), este es el lugar natural para engancharlo,
        // ya que aquí es donde se conoce cada nuevo `outputText` calculado.
    }

    // MARK: - Actions

    /// Copia el resultado actual al portapapeles del sistema.
    func copyOutputToClipboard() {
        guard !outputText.isEmpty else { return }
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(outputText, forType: .string)
    }

    /// Limpia el campo de entrada. El resultado se limpia solo,
    /// ya que el pipeline de Combine reacciona automáticamente.
    func clearAll() {
        inputText = ""
    }

    // MARK: - FIXME

    // FIXME: Si el texto de entrada es muy largo (ej. varios párrafos),
    // UnicodeCode.encode recorre cada unicodeScalar sin límite, lo que
    // puede generar un resultado extremadamente largo y lento de renderizar
    // en el TextEditor. Considerar truncar o paginar el resultado para
    // entradas por encima de cierto tamaño.

    // MARK: - NOTE

    // NOTE: A diferencia de BinaryViewModel/AsciiViewModel (que trabajan
    // sobre bytes UTF-8), este ViewModel opera sobre `Unicode.Scalar`,
    // por lo que soporta el rango completo de Unicode, incluyendo emojis
    // y caracteres fuera del plano básico multilingüe (BMP).
}
