//
//  HelpView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 15/07/26.
//

import SwiftUI

// MARK: - Help View

/// Displays the application's help screen with usage instructions
/// and a quick Morse code reference.
struct HelpView: View {

    // MARK: - App Storage

    /// Stores the user's preferred appearance.
    @AppStorage("appTheme")
    private var appTheme: AppTheme = .system

    // MARK: - Environment

    @Environment(\.dismiss)
    private var dismiss

    // MARK: - Help Sections

    /// List of help topics displayed in the interface.
    private let sections: [HelpSection] = [

        HelpSection(
            icon: "text.cursor",
            iconColor: .blue,
            title: "Convertir texto a Morse",
            description: "Elige el modo \"Texto → Morse\", escribe cualquier texto en el campo de entrada y el código Morse aparecerá automáticamente en \"Resultado\". Los espacios entre palabras se representan con \"/\"."
        ),

        HelpSection(
            icon: "arrow.left.arrow.right",
            iconColor: .indigo,
            title: "Convertir Morse a texto",
            description: "Cambia al modo \"Morse → Texto\". Escribe el código separando cada letra con un espacio y cada palabra con \" / \" (espacio, barra, espacio)."
        ),

        HelpSection(
            icon: "hand.point.up.braille.fill",
            iconColor: .teal,
            title: "Convertir texto a Braille",
            description: "Ve a la pestaña \"Braille\", elige el modo \"Texto → Braille\" y escribe cualquier texto. El resultado se muestra en celdas Braille Unicode, incluyendo mayúsculas y números."
        ),

        HelpSection(
            icon: "arrow.left.arrow.right",
            iconColor: .mint,
            title: "Convertir Braille a texto",
            description: "Cambia al modo \"Braille → Texto\" dentro de la pestaña Braille y escribe o pega los símbolos Braille para obtener el texto equivalente."
        ),

        HelpSection(
            icon: "antenna.radiowaves.left.and.right",
            iconColor: .red,
            title: "Convertir texto a NATO",
            description: "Ve a la pestaña \"NATO\", elige el modo \"Texto → NATO\" y escribe cualquier texto. Cada letra y número se traduce a su palabra fonética (ej. \"A\" = \"Alfa\"). Los espacios entre palabras se representan con \"/\"."
        ),

        HelpSection(
            icon: "arrow.left.arrow.right",
            iconColor: .pink,
            title: "Convertir NATO a texto",
            description: "Cambia al modo \"NATO → Texto\" dentro de la pestaña NATO y escribe las palabras fonéticas separadas por espacio (ej. \"Hotel Oscar Lima Alfa\") para obtener el texto equivalente."
        ),

        HelpSection(
            icon: "number",
            iconColor: .cyan,
            title: "Convertir texto a Binario",
            description: "Ve a la pestaña \"Binario\", elige el modo \"Texto → Binario\" y escribe cualquier texto. Cada carácter se traduce a un byte de 8 bits (ej. \"A\" = \"01000001\"), separados por espacios."
        ),

        HelpSection(
            icon: "arrow.left.arrow.right",
            iconColor: .yellow,
            title: "Convertir Binario a texto",
            description: "Cambia al modo \"Binario → Texto\" dentro de la pestaña Binario y escribe los bytes separados por espacio (ej. \"01001000 01101111 01101100 01100001\") para obtener el texto equivalente."
        ),

        HelpSection(
            icon: "textformat.123",
            iconColor: .brown,
            title: "Convertir texto a ASCII",
            description: "Ve a la pestaña \"ASCII\", elige el modo \"Texto → ASCII\" y escribe cualquier texto. Cada carácter se traduce a su código decimal (ej. \"A\" = \"65\"), separados por espacios."
        ),

        HelpSection(
            icon: "arrow.left.arrow.right",
            iconColor: .gray,
            title: "Convertir ASCII a texto",
            description: "Cambia al modo \"ASCII → Texto\" dentro de la pestaña ASCII y escribe los códigos decimales separados por espacio (ej. \"72 111 108 97\") para obtener el texto equivalente."
        ),

        HelpSection(
            icon: "doc.on.doc",
            iconColor: .green,
            title: "Copiar el resultado",
            description: "Usa el botón \"Copiar resultado\" para llevar el texto convertido al portapapeles y pegarlo donde lo necesites."
        ),

        HelpSection(
            icon: "circle.lefthalf.filled",
            iconColor: .purple,
            title: "Cambiar apariencia",
            description: "Desde el ícono de sol/luna en la barra de herramientas puedes elegir Sistema, Claro u Oscuro."
        ),

        HelpSection(
            icon: "sparkles",
            iconColor: .orange,
            title: "Ver novedades",
            description: "El ícono de destellos (✨) en la barra de herramientas muestra la lista completa de funciones de Signalist en cualquier momento."
        )

        // TODO:
        // Add more help topics as new features are introduced.
    ]

    // MARK: - Body

    var body: some View {

        VStack(spacing: 0) {

            // MARK: Header

            VStack(spacing: 14) {

                ZStack {

                    Circle()
                        .fill(Theme.brandGradient)
                        .frame(width: 64, height: 64)
                        .shadow(
                            color: Theme.gradientEnd.opacity(0.35),
                            radius: 10,
                            y: 4
                        )

                    Image(systemName: "questionmark")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.top, 32)

                Text("Ayuda de Signalist")
                    .font(.system(size: 24,
                                  weight: .bold,
                                  design: .rounded))

                Text("Todo lo que necesitas saber para usar la app")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 24)

            // MARK: Help Content

            ScrollView {

                VStack(alignment: .leading, spacing: 20) {

                    ForEach(sections) { section in
                        HelpRow(section: section)
                    }

                    morseReferenceCard
                    brailleReferenceCard
                    natoReferenceCard
                    binaryReferenceCard
                    asciiReferenceCard
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
            }

            Divider()

            // MARK: Dismiss Button

            Button {
                dismiss()
            } label: {

                Text("Listo")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(20)

            // NOTE:
            // Closing this view simply dismisses the sheet.
        }
        .frame(width: 480, height: 620)
        .background(Color(nsColor: .windowBackgroundColor))
        .preferredColorScheme(appTheme.colorScheme)

        // FIXME:
        // Consider making the window size adaptive for smaller
        // and larger macOS displays.
    }

    // MARK: - Morse Reference Card

    /// Displays a compact Morse code reference.
    private var morseReferenceCard: some View {

        VStack(alignment: .leading, spacing: 10) {

            Label(
                "Referencia rápida — Morse",
                systemImage: "list.bullet.rectangle"
            )
            .font(.system(size: 14, weight: .semibold))

            Text(
                "A: •−   B: −•••   C: −•−•   D: −••   E: •\nS: •••   O: −−−   (SOS = ••• −−− •••)"
            )
            .font(.system(.footnote, design: .monospaced))
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(0.05))
        )

        // NOTE:
        // Frequently used Morse characters are intentionally kept
        // short to avoid visual clutter.
    }

    // MARK: - Braille Reference Card

    /// Displays a compact Braille code reference, including how
    /// capital letters and numbers are represented.
    private var brailleReferenceCard: some View {

        VStack(alignment: .leading, spacing: 10) {

            Label(
                "Referencia rápida — Braille",
                systemImage: "list.bullet.rectangle"
            )
            .font(.system(size: 14, weight: .semibold))

            Text(
                "A: ⠁   B: ⠃   C: ⠉   D: ⠙   E: ⠑\n⠠ antes de una letra = mayúscula\n⠼ antes de un número = modo numérico (ej. ⠼⠁ = \"1\")"
            )
            .font(.system(.footnote, design: .monospaced))
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(0.05))
        )

        // NOTE:
        // Explains the two special signs (capital and number) since
        // they aren't obvious from single-letter Braille cells alone.
    }

    // MARK: - NATO Reference Card

    /// Displays a compact NATO phonetic alphabet reference.
    private var natoReferenceCard: some View {

        VStack(alignment: .leading, spacing: 10) {

            Label(
                "Referencia rápida — NATO",
                systemImage: "list.bullet.rectangle"
            )
            .font(.system(size: 14, weight: .semibold))

            Text(
                "A: Alfa   B: Bravo   C: Charlie   D: Delta   E: Echo\nLos números también tienen palabra propia (ej. \"1\" = \"One\")."
            )
            .font(.system(.footnote, design: .monospaced))
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(0.05))
        )

        // NOTE:
        // Shows just the first few letters as a quick reminder;
        // the full alphabet is available inside the app itself.
    }

    // MARK: - Binary Reference Card

    /// Displays a compact binary (ASCII) reference.
    private var binaryReferenceCard: some View {

        VStack(alignment: .leading, spacing: 10) {

            Label(
                "Referencia rápida — Binario",
                systemImage: "list.bullet.rectangle"
            )
            .font(.system(size: 14, weight: .semibold))

            Text(
                "A: 01000001   B: 01000010   a: 01100001\nCada carácter ocupa 8 bits (1 byte), separados por espacios."
            )
            .font(.system(.footnote, design: .monospaced))
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(0.05))
        )

        // NOTE:
        // Reminds the user that binary is case-sensitive since
        // uppercase and lowercase letters map to different bytes.
    }

    // MARK: - ASCII Reference Card

    /// Displays a compact ASCII decimal code reference.
    private var asciiReferenceCard: some View {

        VStack(alignment: .leading, spacing: 10) {

            Label(
                "Referencia rápida — ASCII",
                systemImage: "list.bullet.rectangle"
            )
            .font(.system(size: 14, weight: .semibold))

            Text(
                "A: 65   B: 66   a: 97   0: 48   Espacio: 32\nCada carácter se representa como un número decimal, separado por espacios."
            )
            .font(.system(.footnote, design: .monospaced))
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(0.05))
        )

        // NOTE:
        // ASCII is also case-sensitive, like binary, since uppercase
        // and lowercase letters map to different decimal codes.
    }
}

// MARK: - Help Section Model

/// Represents a help topic displayed in the help screen.
private struct HelpSection: Identifiable {

    // MARK: - Properties

    let id = UUID()
    let icon: String
    let iconColor: Color
    let title: String
    let description: String

    // TODO:
    // Support localized help content in future versions.
}

// MARK: - Help Row

/// Displays a single help topic.
private struct HelpRow: View {

    // MARK: - Properties

    let section: HelpSection

    // MARK: - Body

    var body: some View {

        HStack(alignment: .top, spacing: 14) {

            Image(systemName: section.icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(section.iconColor)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 3) {

                Text(section.title)
                    .font(.system(size: 14, weight: .semibold))

                Text(section.description)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }

        // NOTE:
        // The row automatically expands based on the description length.
    }
}

// MARK: - Previews

#Preview {
    HelpView()
}

#Preview("Dark") {
    HelpView()
        .preferredColorScheme(.dark)
}
