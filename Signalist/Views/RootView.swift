//
//  RootView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 22/07/26.
//

import SwiftUI

/// Vista raíz de Signalist.
///
/// Administra las pestañas principales de la aplicación, el tema global,
/// la barra de herramientas y la presentación de las vistas de ayuda
/// y novedades.
struct RootView: View {

    // MARK: - Shared ViewModels

    /// ViewModel compartido del conversor Morse.
    @StateObject private var morseViewModel = MorseViewModel()

    /// ViewModel compartido del conversor Braille.
    @StateObject private var brailleViewModel = BrailleViewModel()

    // MARK: - App Storage

    /// Apariencia seleccionada por el usuario.
    @AppStorage("appTheme")
    private var appTheme: AppTheme = .system

    /// Indica si el usuario ya visualizó la ventana de novedades.
    @AppStorage("hasSeenWhatsNew")
    private var hasSeenWhatsNew: Bool = false

    // MARK: - View State

    /// Controla la presentación de la ventana "What's New".
    @State private var showWhatsNew: Bool = false

    /// Pestaña actualmente seleccionada.
    @State private var selectedTab: Int = 0

    // MARK: - Environment

    /// Administrador encargado de mostrar la ventana de ayuda.
    @EnvironmentObject private var helpCenter: HelpCenter

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {

            ContentView(viewModel: morseViewModel)
                .tabItem {
                    Label(
                        "Morse",
                        systemImage: "dot.radiowaves.left.and.right"
                    )
                }
                .tag(0)

            BrailleView(viewModel: brailleViewModel)
                .tabItem {
                    Label(
                        "Braille",
                        systemImage: "hand.point.up.braille.fill"
                    )
                }
                .tag(1)
        }
        .preferredColorScheme(appTheme.colorScheme)

        // MARK: - Toolbar

        /// Barra de herramientas principal compartida por toda la aplicación.
        .toolbar {

            ToolbarItem(placement: .navigation) {
                Spacer()
            }

            // El control de sonido únicamente está disponible
            // para el conversor Morse.
            if selectedTab == 0 {

                ToolbarItem(placement: .primaryAction) {

                    Button {

                        morseViewModel.isSoundEnabled.toggle()

                        if !morseViewModel.isSoundEnabled {
                            morseViewModel.soundPlayer.stop()
                        }

                    } label: {

                        Image(systemName:
                                morseViewModel.isSoundEnabled
                              ? "speaker.wave.2.fill"
                              : "speaker.slash.fill")
                    }
                    .help(
                        morseViewModel.isSoundEnabled
                        ? "Silenciar sonido"
                        : "Activar sonido"
                    )
                }
            }

            ToolbarItem(placement: .primaryAction) {

                Button {
                    showWhatsNew = true

                } label: {
                    Image(systemName: "sparkles")
                }
                .help("Ver novedades")
            }

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

        .sheet(isPresented: $showWhatsNew) {

            WhatsNewView(
                features: WhatsNewFeature.currentFeatures,
                headerIcon:
                    selectedTab == 0
                    ? "dot.radiowaves.left.and.right"
                    : "hand.point.up.braille.fill"
            ) {

                hasSeenWhatsNew = true
                showWhatsNew = false
            }
        }

        .sheet(isPresented: $helpCenter.isShowingHelp) {
            HelpView()
        }
    }

    // MARK: - Theme Menu

    /// Menú que permite cambiar la apariencia global
    /// de la aplicación.
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

    // MARK: - TODO

    // TODO: Agregar nuevas pestañas para futuros sistemas de codificación
    // como ASCII, Binario, Base64, Hexadecimal y Código César.

    // TODO: Permitir que la pestaña inicial pueda configurarse
    // desde las preferencias de la aplicación.

    // MARK: - FIXME

    // FIXME: Si en el futuro se agregan más pestañas,
    // reemplazar el uso de Int por un enum para mejorar la
    // legibilidad y el mantenimiento del código.

    // MARK: - NOTE

    // NOTE: RootView actúa como contenedor principal de toda la aplicación.
    // Comparte los ViewModels entre pestañas para conservar el estado
    // mientras el usuario navega entre Morse y Braille.
}

// MARK: - Preview

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
