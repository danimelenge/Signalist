# Primeros pasos

Compila y ejecuta Signalist en menos de un minuto.

@Metadata {
    @PageColor(green)
}

## Requisitos

- macOS 13 o superior
- Xcode 15.2 (Swift 5.9)

## Compilar

@TabNavigator {
    @Tab("Xcode") {
        1. Abre `Signalist.xcodeproj`.
        2. Selecciona el esquema **Signalist**.
        3. Pulsa **⌘R**.
    }
    @Tab("Terminal") {
        ```bash
        git clone https://github.com/danimelenge/signalist.git
        cd signalist
        xcodebuild -scheme Signalist build
        ```
    }
}

## Tu primera conversión

Escribe `SOS` en la pestaña **Morse**: el resultado es `... --- ...`. Cambia el selector a *Morse → Texto* para revertirlo.

## See Also

- <doc:Conversions>
