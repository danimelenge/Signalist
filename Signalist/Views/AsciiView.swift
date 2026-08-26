//
//  AsciiView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 24/08/26.
//

import SwiftUI

/// Vista principal del conversor de código ASCII.
///
/// Permite convertir texto a valores ASCII y valores ASCII
/// nuevamente a texto de forma bidireccional.
struct AsciiView: View {

    // MARK: - Properties

    /// ViewModel encargado de gestionar el estado y la lógica
    /// de conversión ASCII.
    @ObservedObject var viewModel: AsciiViewModel

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

    /// Encabezado principal de la vista ASCII.
    ///
    /// Muestra el icono, el título y una breve descripción
    /// de la funcionalidad disponible.
    private var header: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(Theme.brandGradient)
                    .frame(width: 56, height: 56)
                    .shadow(
                        color: Theme.gradientEnd.opacity(0.35),
                        radius: 10,
                        y: 4
                    )

                Image(systemName: "textformat.123")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }

            Text("ASCII")
                .font(
                    .system(
                        size: 28,
                        weight: .bold,
                        design: .rounded
                    )
                )

            Text("Convierte texto a códigos ASCII al instante")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    // MARK: - Conversion Mode Picker

    /// Selector del sentido de conversión.
    ///
    /// Permite cambiar entre:
    /// - Texto → ASCII
    /// - ASCII → Texto
    private var modePicker: some View {
        Picker(
            "Modo",
            selection: $viewModel.mode.animation(.snappy)
        ) {
            ForEach(AsciiConversionMode.allCases) { option in
                Text(option.rawValue)
                    .tag(option)
            }
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 360)
    }

    // MARK: - Input Card

    /// Tarjeta que contiene el campo de entrada.
    ///
    /// El texto mostrado en la etiqueta cambia dependiendo
    /// del modo de conversión seleccionado.
    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 10) {

            Label(
                viewModel.mode == .textToAscii
                ? "Texto de entrada"
                : "ASCII de entrada",
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
                        .fill(
                            Color(nsColor: .textBackgroundColor)
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            Color.primary.opacity(0.08),
                            lineWidth: 1
                        )
                )
        }
        .padding(16)
        .background(cardBackground)
    }

    // MARK: - Swap Indicator

    /// Indicador visual que representa el flujo de conversión
    /// entre la entrada y el resultado.
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
    ///
    /// Incluye un indicador visual de estado y el número
    /// de caracteres del resultado.
    private var outputCard: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {

                Label {
                    Text("Resultado")
                        .font(.headline)

                } icon: {
                    Image(
                        systemName:
                            viewModel.outputText.isEmpty
                            ? "circle"
                            : "checkmark.circle.fill"
                    )
                    .font(.headline)
                    .foregroundStyle(
                        viewModel.outputText.isEmpty
                        ? Color.secondary
                        : Color.green
                    )
                    .scaleEffect(
                        viewModel.outputText.isEmpty
                        ? 1
                        : 1.15
                    )
                    .animation(
                        .spring(
                            response: 0.35,
                            dampingFraction: 0.5
                        ),
                        value: viewModel.outputText.isEmpty
                    )
                }

                Spacer()

                if !viewModel.outputText.isEmpty {
                    Text(
                        "\(viewModel.outputText.count) caracteres"
                    )
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
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
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
                    .strokeBorder(
                        Color.primary.opacity(0.08),
                        lineWidth: 1
                    )
            )
            .animation(
                .easeInOut(duration: 0.2),
                value: viewModel.outputText
            )
        }
        .padding(16)
        .background(cardBackground)
    }

    // MARK: - Action Buttons

    /// Botones disponibles para interactuar con el resultado.
    ///
    /// Permite copiar el resultado al portapapeles o
    /// limpiar completamente el contenido de entrada.
    private var actionButtons: some View {
        HStack(spacing: 12) {

            // MARK: Copy Button

            Button {
                viewModel.copyOutputToClipboard()
            } label: {
                Label(
                    "Copiar resultado",
                    systemImage: "doc.on.doc"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewModel.outputText.isEmpty)

            // MARK: Clear Button

            Button(role: .destructive) {
                withAnimation(.snappy) {
                    viewModel.clearAll()
                }
            } label: {
                Label(
                    "Limpiar",
                    systemImage: "trash"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }

    // MARK: - Shared Styles

    /// Fondo reutilizable para las tarjetas de la interfaz.
    ///
    /// Utiliza el material del sistema para adaptarse
    /// automáticamente al modo claro u oscuro.
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.regularMaterial)
            .shadow(
                color: .black.opacity(0.06),
                radius: 8,
                y: 2
            )
    }

    // MARK: - TODO

    // TODO: Agregar soporte para diferentes formatos de
    // representación ASCII, como decimal, hexadecimal y octal.

    // TODO: Permitir configurar el separador utilizado
    // entre los valores ASCII.

    // MARK: - FIXME

    // FIXME: Revisar el manejo de caracteres que no cuentan
    // con una representación ASCII estándar.

    // FIXME: Validar entradas ASCII inválidas antes de
    // realizar la conversión inversa.

    // MARK: - NOTE

    // NOTE: La conversión y el procesamiento de los datos
    // se gestionan desde AsciiViewModel.

    // NOTE: El ViewModel utiliza Combine para actualizar
    // automáticamente el resultado mientras el usuario escribe.

    // NOTE: Esta vista está diseñada para macOS y utiliza
    // componentes específicos de SwiftUI para la plataforma.
}

// MARK: - Preview

#Preview {
    AsciiView(
        viewModel: AsciiViewModel()
    )
}

// MARK: - Dark Preview

#Preview("Dark") {
    AsciiView(
        viewModel: AsciiViewModel()
    )
    .preferredColorScheme(.dark)
}
