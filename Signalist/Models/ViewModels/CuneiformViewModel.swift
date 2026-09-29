//
//  CuneiformViewModel.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 29/09/26.
//

import Foundation
import Combine
import AppKit

// MARK: - Cuneiform ViewModel

/// Maneja el estado y la lógica de conversión Texto ↔ Cuneiforme.
/// Sigue el mismo patrón reactivo con Combine que los demás
/// ViewModels de conversión de la app.
@MainActor
final class CuneiformViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var inputText: String = ""
    @Published var mode: CuneiformConversionMode = .textToCuneiform
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
                case .textToCuneiform:
                    return CuneiformCode.encode(text)
                case .cuneiformToText:
                    return CuneiformCode.decode(text)
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
