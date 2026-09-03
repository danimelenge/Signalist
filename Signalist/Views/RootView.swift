//
//  RootView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 22/07/26.
//

import SwiftUI

/// Vista raíz de Signalist.
///
/// Administra las pestañas principales de la aplicación, los ViewModels
/// compartidos, el tema global, la barra de herramientas y la presentación
/// de las vistas de ayuda y novedades.
struct RootView: View {

    // MARK: - Shared ViewModels

    /// ViewModel encargado de la conversión Morse.
    @StateObject private var morseViewModel = MorseViewModel()

    /// ViewModel encargado de la conversión Braille.
    @StateObject private var brailleViewModel = BrailleViewModel()

    /// ViewModel encargado de la conversión NATO.
    @StateObject private var natoViewModel = NatoViewModel()

    /// ViewModel encargado de la conversión Binaria.
    @StateObject private var binaryViewModel = BinaryViewModel()

    /// ViewModel encargado de la conversión ASCII.
    @StateObject private var asciiViewModel = AsciiViewModel()

    /// ViewModel encargado de la conversión Unicode.
    @StateObject private var unicodeViewModel = UnicodeViewModel()

    /// ViewModel encargado de la conversión Base64.
    @StateObject private var base64ViewModel = Base64ViewModel()

    // MARK: - App Storage

    /// Preferencia de apariencia seleccionada por el usuario.
    @AppStorage("appTheme")
    private var appTheme: AppTheme = .system

    /// Indica si el usuario ya visualizó la ventana de novedades.
    @AppStorage("hasSeenWhatsNew")
    private var hasSeenWhatsNew: Bool = false

    // MARK: - View State

    /// Controla la presentación de la ventana de novedades.
    @State private var showWhatsNew: Bool = false

    /// Índice de la pestaña actualmente seleccionada.
    @State private var selectedTab: Int = 0

    // MARK: - Environment

    /// Centro de ayuda compartido por toda la aplicación.
    @EnvironmentObject private var helpCenter: HelpCenter

    // MARK: - Body

    var body: some View {

        TabView(selection: $selectedTab) {

            // MARK: Morse

            /// Pestaña principal para convertir texto a Morse
            /// y Morse a texto.
            ContentView(viewModel: morseViewModel)
                .tabItem {
                    Label(
                        "Morse",
                        systemImage: "dot.radiowaves.left.and.right"
                    )
                }
                .tag(0)

            // MARK: Braille

            /// Pestaña para convertir texto a Braille
            /// y Braille a texto.
            BrailleView(viewModel: brailleViewModel)
                .tabItem {
                    Label(
                        "Braille",
                        systemImage: "hand.point.up.braille.fill"
                    )
                }
                .tag(1)

            // MARK: NATO

            /// Pestaña para convertir texto al alfabeto fonético NATO
            /// y NATO a texto.
            NatoView(viewModel: natoViewModel)
                .tabItem {
                    Label(
                        "NATO",
                        systemImage: "antenna.radiowaves.left.and.right"
                    )
                }
                .tag(2)

            // MARK: Binary

            /// Pestaña para convertir texto a código binario
            /// y binario a texto.
            BinaryView(viewModel: binaryViewModel)
                .tabItem {
                    Label(
                        "Binario",
                        systemImage: "number"
                    )
                }
                .tag(3)

            // MARK: ASCII

            /// Pestaña para convertir texto a códigos ASCII
            /// y ASCII a texto.
            AsciiView(viewModel: asciiViewModel)
                .tabItem {
                    Label(
                        "ASCII",
                        systemImage: "textformat.123"
                    )
                }
                .tag(4)

            // MARK: Unicode

            /// Pestaña para convertir texto a códigos Unicode
            /// y Unicode a texto.
            UnicodeView(viewModel: unicodeViewModel)
                .tabItem {
                    Label(
                        "Unicode",
                        systemImage: "character.book.closed.fill"
                    )
                }
                .tag(5)

            // MARK: Base64

            /// Pestaña para convertir texto a Base64
            /// y Base64 a texto.
            Base64View(viewModel: base64ViewModel)
                .tabItem {
                    Label(
                        "Base64",
                        systemImage: "chevron.left.forwardslash.chevron.right"
                    )
                }
                .tag(6)
        }
        .preferredColorScheme(appTheme.colorScheme)

        // MARK: - Toolbar

        .toolbar {

            // MARK: Navigation Spacer

            /// Empuja los elementos de la barra de herramientas
            /// hacia el lado derecho de la ventana.
            ToolbarItem(placement: .navigation) {
                Spacer()
            }

            // MARK: Morse Sound

            /// Muestra el control de sonido únicamente en la pestaña Morse.
            if selectedTab == 0 {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        morseViewModel.isSoundEnabled.toggle()

                        if !morseViewModel.isSoundEnabled {
                            morseViewModel.soundPlayer.stop()
                        }
                    } label: {
                        Image(
                            systemName: morseViewModel.isSoundEnabled
                            ? "speaker.wave.2.fill"
                            : "speaker.slash.fill"
                        )
                    }
                    .help(
                        morseViewModel.isSoundEnabled
                        ? "Silenciar sonido"
                        : "Activar sonido"
                    )
                }
            }

            // MARK: What's New

            /// Abre la ventana con las novedades de Signalist.
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showWhatsNew = true
                } label: {
                    Image(systemName: "sparkles")
                }
                .help("Ver novedades")
            }

            // MARK: Theme

            /// Menú para cambiar la apariencia de la aplicación.
            ToolbarItem(placement: .primaryAction) {
                themeMenu
            }
        }

        // MARK: - Lifecycle

        .onAppear {
            if !hasSeenWhatsNew {
                showWhatsNew = true
            }
        }

        // MARK: - Sheets

        /// Presenta la ventana de novedades.
        .sheet(isPresented: $showWhatsNew) {
            WhatsNewView(
                features: WhatsNewFeature.currentFeatures,
                headerIcon: headerIconForCurrentTab
            ) {
                hasSeenWhatsNew = true
                showWhatsNew = false
            }
        }

        /// Presenta la ventana de ayuda.
        .sheet(isPresented: $helpCenter.isShowingHelp) {
            HelpView()
        }
    }

    // MARK: - Helpers

    /// Devuelve el SF Symbol correspondiente a la pestaña seleccionada.
    ///
    /// Este icono se utiliza como encabezado de la ventana de novedades
    /// para mostrar visualmente qué sección está activa.
    private var headerIconForCurrentTab: String {

        switch selectedTab {

        case 0:
            // Morse
            return "dot.radiowaves.left.and.right"

        case 1:
            // Braille
            return "hand.point.up.braille.fill"

        case 2:
            // NATO
            return "antenna.radiowaves.left.and.right"

        case 3:
            // Binario
            return "number"

        case 4:
            // ASCII
            return "textformat.123"

        case 5:
            // Unicode
            return "character.book.closed.fill"

        default:
            // Base64 / Fallback
            return "chevron.left.forwardslash.chevron.right"
        }
    }

    // MARK: - Theme Menu

    /// Menú que permite cambiar la apariencia de Signalist.
    ///
    /// Las opciones disponibles son las definidas en `AppTheme`.
    /// La selección se guarda mediante `AppStorage`.
    private var themeMenu: some View {

        Menu {

            ForEach(AppTheme.allCases) { theme in

                Button {
                    withAnimation(.easeInOut) {
                        appTheme = theme
                    }
                } label: {
                    Label(
                        theme.rawValue,
                        systemImage: theme.icon
                    )

                    if appTheme == theme {
                        Image(systemName: "checkmark")
                    }
                }
            }

        } label: {
            Image(systemName: appTheme.icon)
        }
        .help("Apariencia")
    }
}

// MARK: - Previews

#Preview {
    RootView()
        .environmentObject(HelpCenter())
}

// MARK: - Dark Preview

#Preview("Dark") {
    RootView()
        .environmentObject(HelpCenter())
        .preferredColorScheme(.dark)
}
