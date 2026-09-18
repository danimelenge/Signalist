//
//  Rot47ViewModel.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 18/09/26.
//

import Foundation
import Combine
import AppKit

// MARK: - ROT47 ViewModel

/// Maneja el estado y la lógica de conversión Texto ↔ ROT47.
/// Sigue el mismo patrón reactivo con Combine que los demás
/// ViewModels de conversión de la app.
@MainActor
final class Rot47ViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var inputText: String = ""
    @Published var mode: Rot47ConversionMode = .textToRot47
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
                case .textToRot47:
                    return Rot47Code.encode(text)
                case .rot47ToText:
                    return Rot47Code.decode(text)
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

    // MARK: - NOTE

    // NOTE: Igual que en Rot13ViewModel, ambos casos del switch llaman
    // a la misma transformación subyacente, ya que ROT47 es simétrico.
}
