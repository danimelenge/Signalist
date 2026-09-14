//
//  SignalistApp.swift
//  Signalist
//

import SwiftUI

// NOTE:
// Signalist no requiere conexión a internet. Todas las conversiones
// (Morse, Braille, NATO, Binario, ASCII, Unicode, Base64, César, ROT13)
// se ejecutan localmente con lógica pura de Swift, sin llamadas de red.

@main
struct SignalistApp: App {
    @StateObject private var helpCenter = HelpCenter()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(helpCenter)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .help) {
                Button("Signalist Help") {
                    helpCenter.isShowingHelp = true
                }
                .keyboardShortcut("?", modifiers: .command)
            }
        }
    }
}
