//
//  Base64View.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 3/09/26.
//

import SwiftUI

// MARK: - Base64 View

/// Vista principal del conversor de código Base64.
struct Base64View: View {

    // MARK: - Properties

    @ObservedObject var viewModel: Base64ViewModel

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

    /// Encabezado principal del conversor Base64.
    private var header: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(Theme.brandGradient)
                    .frame(width: 56, height: 56)
                    .shadow(color: Theme.gradientEnd.opacity(0.35),
                            radius: 10,
                            y: 4)

                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }

            Text("Base64")
                .font(.system(size: 28,
                              weight: .bold,
                              design: .rounded))

            Text("Convierte texto a Base64 al instante")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    // MARK: - Conversion Mode Picker

    /// Selector del sentido de conversión.
    private var modePicker: some View {
        Picker("Modo", selection: $viewModel.mode.animation(.snappy)) {
            ForEach(Base64ConversionMode.allCases) { option in
                Text(option.rawValue)
                    .tag(option)
            }
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 360)
    }

    // MARK: - Input Card

    /// Tarjeta donde el usuario escribe el texto o el Base64.
    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 10) {

            Label(
                viewModel.mode == .textToBase64 ?
                "Texto de entrada" :
                "Base64 de entrada",
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

            ScrollView {
                Text(
                    viewModel.outputText.isEmpty
                    ? "Aquí aparecerá el resultado..."
                    : viewModel.outputText
                )
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(
                    viewModel.outputText.isEmpty
                    ? .tertiary
                    : .primary
                )
                .textSelection(.enabled)
                .padding(12)
            }
            .frame(height: 110)
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

// MARK: - Preview

#Preview {
    Base64View(viewModel: Base64ViewModel())
}

// MARK: - Dark Preview

#Preview("Dark") {
    Base64View(viewModel: Base64ViewModel())
        .preferredColorScheme(.dark)
}
