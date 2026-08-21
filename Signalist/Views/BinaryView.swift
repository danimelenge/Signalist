//
//  BinaryView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 19/08/26.
//

import SwiftUI

// MARK: - BinaryView

/// Vista principal del conversor de código Binario.
///
/// Permite convertir texto a código binario y código binario
/// a texto mediante un selector de modo.
struct BinaryView: View {

    // MARK: - Properties

    /// ViewModel que administra el estado y la lógica de conversión.
    @ObservedObject var viewModel: BinaryViewModel

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

    /// Encabezado principal de la vista.
    ///
    /// Muestra el icono, el nombre del conversor y una breve
    /// descripción de su funcionalidad.
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

                Image(systemName: "number")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }

            Text("Binario")
                .font(
                    .system(
                        size: 28,
                        weight: .bold,
                        design: .rounded
                    )
                )

            Text("Convierte texto a código binario al instante")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    // MARK: - Conversion Mode Picker

    /// Selector que permite elegir la dirección de conversión.
    ///
    /// Las opciones disponibles son:
    /// - Texto → Binario
    /// - Binario → Texto
    private var modePicker: some View {
        Picker(
            "Modo",
            selection: $viewModel.mode.animation(.snappy)
        ) {
            ForEach(BinaryConversionMode.allCases) { option in
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
    /// El texto de la etiqueta cambia dependiendo del modo
    /// de conversión seleccionado.
    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 10) {

            Label(
                viewModel.mode == .textToBinary
                ? "Texto de entrada"
                : "Binario de entrada",
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
    /// desde la entrada hasta el resultado.
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
    /// También muestra un indicador visual cuando existe
    /// contenido en el resultado y el número de caracteres.
    private var outputCard: some View {
        VStack(alignment: .leading, spacing: 10) {

            // MARK: Output Header

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

                // MARK: Character Count

                if !viewModel.outputText.isEmpty {
                    Text(
                        "\(viewModel.outputText.count) caracteres"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
                }
            }

            // MARK: Output Text

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
    /// Permite copiar el resultado al portapapeles o limpiar
    /// completamente el campo de entrada.
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

    /// Fondo reutilizable utilizado por las tarjetas de entrada
    /// y resultado.
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

    // TODO: Agregar soporte para diferentes separadores binarios
    //       y permitir seleccionar entre espacios, guiones u otros
    //       formatos de separación.

    // MARK: - FIXME

    // FIXME: Validar y mostrar un mensaje cuando el usuario
    //         introduzca una secuencia binaria inválida.

    // MARK: - NOTE

    // NOTE: La interfaz utiliza una fuente monoespaciada para que
    //       las secuencias binarias sean más fáciles de visualizar.

    // NOTE: BinaryView utiliza BinaryViewModel para separar la lógica
    //       de conversión de la interfaz siguiendo el patrón MVVM.
}

// MARK: - Preview

#Preview {
    BinaryView(
        viewModel: BinaryViewModel()
    )
}

// MARK: - Dark Preview

#Preview("Dark") {
    BinaryView(
        viewModel: BinaryViewModel()
    )
    .preferredColorScheme(.dark)
}
