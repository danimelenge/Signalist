//
//  BinaryViewModel.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 19/08/26.
//


import Foundation
import Combine
import AppKit

@MainActor
final class BinaryViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var mode: BinaryConversionMode = .textToBinary
    @Published private(set) var outputText: String = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        Publishers.CombineLatest($inputText, $mode)
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .map { text, mode -> String in
                switch mode {
                case .textToBinary:
                    return BinaryCode.encode(text)
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
