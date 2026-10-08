//
//  MayaViewModel.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 8/10/26.
//


import Foundation
import Combine
import AppKit

// MARK: - Maya ViewModel

/// Maneja el estado y la lógica de conversión Número ↔ Numerales mayas.
/// Sigue el mismo patrón reactivo con Combine que los demás
/// ViewModels de conversión de la app.
@MainActor
final class MayaViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var inputText: String = ""
    @Published var mode: MayaConversionMode = .textToMaya
    @Published private(set) var outputText: String = ""

    // MARK: - Drawing Support

    /// Dígitos de cada número del resultado, para dibujarlos en la vista.
    var numeralGroups: [[Int]] {
        MayaCode.digitGroups(in: outputText)
    }

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
                case .textToMaya:
                    return MayaCode.encode(text)
                case .mayaToText:
                    return MayaCode.decode(text)
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
