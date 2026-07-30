//
//  RootView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 22/07/26.
//


import SwiftUI

struct RootView: View {

    // MARK: - Shared ViewModels

    @StateObject private var morseViewModel = MorseViewModel()
    @StateObject private var brailleViewModel = BrailleViewModel()

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
        }
        .preferredColorScheme(appTheme.colorScheme)

        // MARK: Toolbar
        // Único toolbar de toda la app. El Spacer en .navigation empuja
        // el resto de los íconos hacia el lado derecho de la ventana.

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
                headerIcon: selectedTab == 0 ? "dot.radiowaves.left.and.right" : "hand.point.up.braille.fill"
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

    /// Permite cambiar la apariencia de toda la aplicación.
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

// MARK: - Preview

#Preview {
    RootView()
        .environmentObject(HelpCenter())
}

#Preview("Dark") {
    RootView()
        .environmentObject(HelpCenter())
        .preferredColorScheme(.dark)
}
