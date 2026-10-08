//
//  MayaView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 8/10/26.
//


import SwiftUI

// MARK: - Maya View

/// Vista principal del conversor de numerales mayas.
struct MayaView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: MayaViewModel

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                modePicker
                inputCard
                swapIndicator
                outputCard
                actionButtons
            }
            .padding(28)
        }
        .frame(minWidth: 520, minHeight: 640)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    // MARK: - Header

    /// Encabezado principal del conversor de numerales mayas.
    private var header: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(Theme.brandGradient)
                    .frame(width: 56, height: 56)
                    .shadow(color: Theme.gradientEnd.opacity(0.35),
                            radius: 10,
                            y: 4)

                Image(systemName: "sun.max.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }

            Text("Maya")
                .font(.system(size: 28,
                              weight: .bold,
                              design: .rounded))

            Text("Convierte números a numerales mayas (base 20)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    // MARK: - Conversion Mode Picker

    /// Selector del sentido de conversión.
    private var modePicker: some View {
        Picker("Modo", selection: $viewModel.mode.animation(.snappy)) {
            ForEach(MayaConversionMode.allCases) { option in
                Text(option.rawValue)
                    .tag(option)
            }
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 360)
    }

    // MARK: - Input Card

    /// Tarjeta donde el usuario escribe los números o los numerales mayas.
    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 10) {

            Label(
                viewModel.mode == .textToMaya ?
                "Números de entrada" :
                "Numerales mayas de entrada",
                systemImage: "text.cursor"
            )
            .font(.headline)
            .foregroundStyle(.primary)

            TextEditor(text: $viewModel.inputText)
                .font(.system(.body, design: .monospaced))
                .scrollContentBackground(.hidden)
                .frame(height: 110)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(nsColor: .textBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.primary.opacity(0.08),
                                      lineWidth: 1)
                )
        }
        .padding(16)
        .background(cardBackground)
    }

    // MARK: - Swap Indicator

    /// Indicador visual que representa el flujo de conversión.
    private var swapIndicator: some View {
        Image(systemName: "arrow.down")
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.secondary)
            .frame(width: 32, height: 32)
            .background(
                Circle()
                    .fill(Color.primary.opacity(0.06))
            )
    }

    // MARK: - Output Card

    /// Tarjeta que muestra el resultado de la conversión.
    private var outputCard: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {

                Label {
                    Text("Resultado")
                        .font(.headline)

                } icon: {
                    Image(systemName:
                            viewModel.outputText.isEmpty
                          ? "circle"
                          : "checkmark.circle.fill")
                        .font(.headline)
                        .foregroundStyle(
                            viewModel.outputText.isEmpty
                            ? Color.secondary
                            : Color.green
                        )
                        .scaleEffect(
                            viewModel.outputText.isEmpty ? 1 : 1.15
                        )
                        .animation(
                            .spring(response: 0.35,
                                    dampingFraction: 0.5),
                            value: viewModel.outputText.isEmpty
                        )
                }

                Spacer()

                if !viewModel.outputText.isEmpty {
                    Text("\(viewModel.outputText.count) caracteres")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .transition(.opacity)
                }
            }

            Group {
                if viewModel.mode == .textToMaya && !viewModel.outputText.isEmpty {

                    // Numerales dibujados, un número por columna
                    ScrollView([.horizontal, .vertical]) {
                        HStack(alignment: .top, spacing: 28) {
                            ForEach(Array(viewModel.numeralGroups.enumerated()), id: \.offset) { _, digits in
                                VStack(spacing: 10) {
                                    ForEach(Array(digits.enumerated()), id: \.offset) { _, digit in
                                        MayaGlyphView(value: digit)
                                    }
                                }
                            }
                        }
                        .padding(12)
                    }

                } else {

                    ScrollView {
                        Text(
                            viewModel.outputText.isEmpty
                            ? "Aquí aparecerá el resultado..."
                            : viewModel.outputText
                        )
                        .font(.system(.title2, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(
                            viewModel.outputText.isEmpty ? .tertiary : .primary
                        )
                        .textSelection(.enabled)
                        .padding(12)
                    }
                }
            }
            .frame(height: (viewModel.mode == .textToMaya && !viewModel.outputText.isEmpty) ? 240 : 110)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primary.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.primary.opacity(0.08),
                                  lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.2),
                       value: viewModel.outputText)
        }
        .padding(16)
        .background(cardBackground)

        // NOTE:
        // En modo Número → Maya los numerales se dibujan con formas
        // (punto, barra y concha) porque el bloque Unicode "Mayan
        // Numerals" no está incluido en las fuentes de muchos Macs y
        // aparecería como cuadros vacíos. El botón "Copiar resultado"
        // sigue copiando los caracteres Unicode reales.
    }

    // MARK: - Action Buttons

    /// Botones para copiar el resultado o limpiar el contenido.
    private var actionButtons: some View {
        HStack(spacing: 12) {

            Button {
                viewModel.copyOutputToClipboard()
            } label: {
                Label("Copiar resultado",
                      systemImage: "doc.on.doc")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewModel.outputText.isEmpty)

            Button(role: .destructive) {
                withAnimation(.snappy) {
                    viewModel.clearAll()
                }
            } label: {
                Label("Limpiar",
                      systemImage: "trash")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }

    // MARK: - Shared Styles

    /// Estilo reutilizable para las tarjetas de la interfaz.
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.regularMaterial)
            .shadow(color: .black.opacity(0.06),
                    radius: 8,
                    y: 2)
    }
}

// MARK: - Maya Glyph View

/// Dibuja un dígito maya (0–19): concha = 0, punto = 1, barra = 5.
/// Los puntos van arriba y las barras abajo, como en la escritura original.
private struct MayaGlyphView: View {

    let value: Int

    var body: some View {
        VStack(spacing: 4) {
            if value == 0 {
                Capsule()
                    .stroke(Color.primary, lineWidth: 2)
                    .frame(width: 44, height: 18)
            } else {
                if value % 5 > 0 {
                    HStack(spacing: 6) {
                        ForEach(0..<(value % 5), id: \.self) { _ in
                            Circle()
                                .fill(Color.primary)
                                .frame(width: 9, height: 9)
                        }
                    }
                }

                ForEach(0..<(value / 5), id: \.self) { _ in
                    Capsule()
                        .fill(Color.primary)
                        .frame(width: 44, height: 8)
                }
            }
        }
        .frame(width: 52)
        .accessibilityLabel("\(value)")
    }
}

// MARK: - Preview

#Preview {
    MayaView(viewModel: MayaViewModel())
}

// MARK: - Dark Preview

#Preview("Dark") {
    MayaView(viewModel: MayaViewModel())
        .preferredColorScheme(.dark)
}
