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
            ContentView(viewModel: morseViewModel)
                .tabItem {
                    Label("Morse", systemImage: "dot.radiowaves.left.and.right")
                }
                .tag(0)

            BrailleView(viewModel: brailleViewModel)
                .tabItem {
                    Label("Braille", systemImage: "hand.point.up.braille.fill")
                }
                .tag(1)

            NatoView(viewModel: natoViewModel)
                .tabItem {
                    Label("NATO", systemImage: "antenna.radiowaves.left.and.right")
                }
                .tag(2)
        }
        .preferredColorScheme(appTheme.colorScheme)

        // MARK: Toolbar

        .toolbar {
            ToolbarItem(placement: .navigation) {
                Spacer()
            }

            if selectedTab == 0 {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        morseViewModel.isSoundEnabled.toggle()
                        if !morseViewModel.isSoundEnabled {
                            morseViewModel.soundPlayer.stop()
                        }
                    } label: {
                        Image(systemName: morseViewModel.isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                    }
                    .help(morseViewModel.isSoundEnabled ? "Silenciar sonido" : "Activar sonido")
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

        // MARK: Lifecycle

        .onAppear {
            if !hasSeenWhatsNew {
                showWhatsNew = true
            }
        }

        // MARK: Sheets

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

    private var headerIconForCurrentTab: String {
        switch selectedTab {
        case 0: return "dot.radiowaves.left.and.right"
        case 1: return "hand.point.up.braille.fill"
        default: return "antenna.radiowaves.left.and.right"
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
                    Label(theme.rawValue, systemImage: theme.icon)
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

#Preview {
    RootView()
        .environmentObject(HelpCenter())
}

#Preview("Dark") {
    RootView()
        .environmentObject(HelpCenter())
        .preferredColorScheme(.dark)
}
