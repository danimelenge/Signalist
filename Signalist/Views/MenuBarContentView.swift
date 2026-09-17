//
//  MenuBarContentView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 16/09/26.
//

import SwiftUI

// MARK: - Menu Bar Content View

/// Contenido que se muestra al hacer clic en el ícono de Signalist
/// en la barra de menú de macOS.
struct MenuBarContentView: View {

    // MARK: - Environment

    @Environment(\.openWindow) private var openWindow

    // MARK: - Body

    var body: some View {

        VStack(alignment: .leading, spacing: 4) {

            Button {
                NSApp.activate(ignoringOtherApps: true)
                openWindow(id: "main")
            } label: {
                Label("Abrir Signalist", systemImage: "macwindow")
            }

            Divider()

            Button {
                NSApp.activate(ignoringOtherApps: true)
            } label: {
                Label("Traer al frente", systemImage: "arrow.up.forward.app")
            }

            Divider()

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Label("Salir de Signalist", systemImage: "power")
            }
            .keyboardShortcut("q", modifiers: .command)
        }
        .padding(6)

        // NOTE:
        // Este menú es intencionalmente breve — solo accesos directos,
        // no duplica la funcionalidad de conversión de la ventana principal.
    }
}
