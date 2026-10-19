//
//  SettingsView.swift
//  Signalist
//

import SwiftUI

// MARK: - Settings View

/// Ventana de Ajustes de Signalist.
///
/// Se muestra con **⌘,** (como en las apps nativas de macOS), desde el
/// menú «Signalist ▸ Ajustes…» o desde el ícono de la barra de menú.
struct SettingsView: View {

    // MARK: - Body

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }

            AboutSettingsView()
                .tabItem {
                    Label("Acerca de", systemImage: "info.circle")
                }
        }
        .frame(width: 440, height: 260)
    }
}

// MARK: - General

private struct GeneralSettingsView: View {

    /// Misma clave que usa `RootView`, así que ambos se mantienen sincronizados.
    @AppStorage("appTheme")
    private var appTheme: AppTheme = .system

    @AppStorage("hasSeenWhatsNew")
    private var hasSeenWhatsNew: Bool = false

    var body: some View {
        Form {
            Picker("Apariencia", selection: $appTheme) {
                ForEach(AppTheme.allCases) { theme in
                    Label(theme.rawValue, systemImage: theme.icon)
                        .tag(theme)
                }
            }
            .pickerStyle(.inline)

            Divider()

            Button("Mostrar novedades de nuevo") {
                hasSeenWhatsNew = false
            }
            .help("Vuelve a mostrar la ventana de novedades la próxima vez que abras Signalist.")
        }
        .formStyle(.grouped)
        .padding(.horizontal, 8)
    }
}

// MARK: - About

private struct AboutSettingsView: View {

    private var version: String {
        let short = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Versión \(short) (\(build))"
    }

    var body: some View {
        VStack(spacing: 8) {
            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .frame(width: 64, height: 64)

            Text("Signalist")
                .font(.title2.bold())

            Text(version)
                .font(.callout)
                .foregroundStyle(.secondary)

            Text("Conversor de texto con 16 códigos y alfabetos.\nFunciona sin conexión.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
}
