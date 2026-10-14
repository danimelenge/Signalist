# Arquitectura MVVM

Cómo se separan modelo, vista‑modelo y vista en cada conversor.

@Metadata {
    @PageColor(purple)
}

## Capas

@Row {
    @Column {
        **Model**

        Structs/enums sin UI. Ejemplo: ``MorseCode``.
    }
    @Column {
        **ViewModel**

        `@MainActor ObservableObject` con Combine. Ejemplo: ``MorseViewModel``.
    }
    @Column {
        **View**

        SwiftUI puro, recibe `@ObservedObject viewModel`.
    }
}

## Pipeline reactivo

Todos los ViewModels combinan texto y modo, esperan 150 ms y recalculan la salida:

```swift
Publishers.CombineLatest($inputText, $mode)
    .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
    .sink { [weak self] text, mode in
        self?.outputText = /* conversión */
    }
    .store(in: &cancellables)
```

`RootView` es dueño de los ViewModels (`@StateObject`) y de una única barra de herramientas compartida por todas las pestañas.

## Estructura

```
Signalist/
├── Models/       # lógica pura
├── ViewModels/   # estado + Combine
├── Views/        # RootView y una vista por pestaña
└── Utilities/    # Theme, MorseSoundPlayer
```
