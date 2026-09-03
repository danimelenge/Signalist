//
//  Base64ViewModel.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 3/09/26.
//

import Foundation
import Combine
import AppKit

// MARK: - Base64 ViewModel

/// Maneja el estado y la lógica de conversión Texto ↔ Base64.
/// Sigue el mismo patrón reactivo con Combine que los demás
/// ViewModels de conversión de la app.
@MainActor
final class Base64ViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var inputText: String = ""
    @Published var mode: Base64ConversionMode = .textToBase64
    @Published private(set) var outputText: String = ""

    // MARK: - Combine

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        setupBindings()
    }

    // MARK: - Bindings

    private func setupBindings() {
        Publishers.CombineLatest($inputText, $mode)
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .map { text, mode -> String in
                switch mode {
                case .textToBase64:
                    return Base64Code.encode(text)
                case .base64ToText:
                    return Base64Code.decode(text)
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
