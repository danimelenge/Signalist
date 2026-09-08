//
//  CaesarViewModel.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 8/09/26.
//

import Foundation
import Combine
import AppKit

// MARK: - Caesar ViewModel

/// Maneja el estado y la lógica de conversión Texto ↔ Cifrado César.
/// A diferencia de los demás ViewModels, incluye un parámetro adicional
/// (`shift`) que también participa en el pipeline reactivo.
@MainActor
final class CaesarViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var inputText: String = ""
    @Published var mode: CaesarConversionMode = .textToCaesar

    /// Desplazamiento del cifrado, entre 1 y 25.
    @Published var shift: Double = 3

    @Published private(set) var outputText: String = ""

    // MARK: - Combine

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        setupBindings()
    }

    // MARK: - Bindings

    private func setupBindings() {
        Publishers.CombineLatest3($inputText, $mode, $shift)
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .map { text, mode, shift -> String in
                let intShift = Int(shift)
                switch mode {
                case .textToCaesar:
                    return CaesarCode.encode(text, shift: intShift)
                case .caesarToText:
                    return CaesarCode.decode(text, shift: intShift)
                }
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.outputText = result
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func copyOutputToClipboard() {
        guard !outputText.isEmpty else { return }
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(outputText, forType: .string)
    }

    func clearAll() {
        inputText = ""
    }
}
