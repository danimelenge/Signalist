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

    // MARK: - App State

    /// Centro compartido para controlar la presentación de la ayuda
    /// desde la ventana principal y los comandos de macOS.
    @StateObject private var helpCenter = HelpCenter()

    // MARK: - App Scenes

    var body: some Scene {

        // MARK: Main Window

        /// Ventana principal de Signalist.
        ///
        /// El identificador permite referenciar esta ventana
        /// específicamente dentro del ciclo de vida de la aplicación.
        WindowGroup(id: "main") {
            RootView()
                .environmentObject(helpCenter)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            // MARK: Help Commands

            /// Reemplaza el menú de ayuda predeterminado de macOS
            /// con el acceso a la ayuda propia de Signalist.
            CommandGroup(replacing: .help) {
                Button("Signalist Help") {
                    helpCenter.isShowingHelp = true
                }
                .keyboardShortcut("?", modifiers: .command)
            }
        }

        // MARK: Menu Bar Extra

        /// Muestra Signalist directamente en la barra de menú de macOS,
        /// junto al reloj, Wi-Fi y otros controles del sistema.
        ///
        /// Permite acceder rápidamente a las funciones de Signalist
        /// sin necesidad de abrir la ventana principal.
        MenuBarExtra(
            "Signalist",
            systemImage: "dot.radiowaves.left.and.right"
        ) {
            MenuBarContentView()
        }
        .menuBarExtraStyle(.menu)
    }
}
