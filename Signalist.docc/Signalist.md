# ``Signalist``

Conversor de texto ↔ 16 códigos y alfabetos, nativo de macOS, hecho con SwiftUI, MVVM y Combine.

@Metadata {
    @PageImage(purpose: icon, source: "signalist-icon", alt: "Icono de Signalist: dos puntos y una raya.")
    @PageImage(purpose: card, source: "signalist-icon", alt: "Icono de Signalist.")
    @PageColor(green)
}

## Overview

Signalist convierte texto en tiempo real (con *debounce* de 150 ms) y funciona **sin conexión**: no hace ninguna llamada de red.

@Row {
    @Column(size: 2) {
        Cada pestaña sigue el mismo patrón: un `Model` con la lógica pura, un `ViewModel` con `@Published` + Combine y una `View` que solo presenta.
    }
    @Column {
        ![Icono de Signalist](signalist-icon)
    }
}

### Empieza aquí

@Links(visualStyle: detailedGrid) {
    - <doc:GettingStarted>
    - <doc:Conversions>
    - <doc:Architecture>
    - <doc:Contributing>
}

## Topics

### Primeros pasos

- <doc:GettingStarted>
- <doc:Conversions>

### Tutorial

- <doc:AddConverter>

### Arquitectura

- <doc:Architecture>
- ``MorseCode``
- ``MorseViewModel``

### Códigos destacados

- ``CaesarCode``
- ``MayaCode``

### Ayuda y novedades

- ``HelpCenter``
- ``WhatsNewFeature``

### Contribuir

- <doc:Contributing>
