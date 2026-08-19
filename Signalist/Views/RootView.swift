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

    @StateObject private var morseViewModel = MorseViewModel()
    @StateObject private var brailleViewModel = BrailleViewModel()
    @StateObject private var natoViewModel = NatoViewModel()
    @StateObject private var binaryViewModel = BinaryViewModel()

    // MARK: - App Storage

    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @AppStorage("hasSeenWhatsNew") private var hasSeenWhatsNew: Bool = false

    // MARK: - View State

    @State private var showWhatsNew: Bool = false
    @State private var selectedTab: Int = 0

    // MARK: - Environment

    @EnvironmentObject private var helpCenter: HelpCenter

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {

            // MARK: Morse

            ContentView(viewModel: morseViewModel)
                .tabItem {
                    Label(
                        "Morse",
                        systemImage: "dot.radiowaves.left.and.right"
                    )
                }
                .tag(0)

            // MARK: Braille

            BrailleView(viewModel: brailleViewModel)
                .tabItem {
                    Label(
                        "Braille",
                        systemImage: "hand.point.up.braille.fill"
                    )
                }
                .tag(1)

            // MARK: NATO

            NatoView(viewModel: natoViewModel)
                .tabItem {
                    Label(
                        "NATO",
                        systemImage: "antenna.radiowaves.left.and.right"
                    )
                }
                .tag(2)

            // MARK: Binary

            BinaryView(viewModel: binaryViewModel)
                .tabItem {
                    Label(
                        "Binario",
                        systemImage: "number"
                    )
                }
                .tag(3)
        }
        .preferredColorScheme(appTheme.colorScheme)

        // MARK: - Toolbar

        .toolbar {

            ToolbarItem(placement: .navigation) {
                Spacer()
            }

            // MARK: Morse Sound

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

            ToolbarItem(placement: .primaryAction) {
                Button {
                    showWhatsNew = true
                } label: {
                    Image(systemName: "sparkles")
                }
                .help("Ver novedades")
            }

            // MARK: Theme

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
                headerIcon: headerIconForCurrentTab
            ) {
                hasSeenWhatsNew = true
                showWhatsNew = false
            }
        }

        .sheet(isPresented: $helpCenter.isShowingHelp) {
            HelpView()
        }
    }

    // MARK: - Helpers

    /// Devuelve el SF Symbol correspondiente a la pestaña seleccionada.
    private var headerIconForCurrentTab: String {
        switch selectedTab {
        case 0:
            return "dot.radiowaves.left.and.right"

        case 1:
            return "hand.point.up.braille.fill"

        case 2:
            return "antenna.radiowaves.left.and.right"

        case 3:
            return "number"

        default:
            return "number"
        }
    }

    // MARK: - Theme Menu

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

#Preview("Dark") {
    RootView()
        .environmentObject(HelpCenter())
        .preferredColorScheme(.dark)
}
