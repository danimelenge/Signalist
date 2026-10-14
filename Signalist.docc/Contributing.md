# Contribuir y publicar la documentación

Genera esta documentación en Xcode y publícala como sitio estático.

@Metadata {
    @PageKind(sampleCode)
    @CallToAction(purpose: link, url: "https://github.com/danimelenge/signalist", label: "Ver en GitHub")
    @PageColor(orange)
}

## En Xcode

1. Abre un archivo `.md` del catálogo y activa **Editor ▸ Assistant ▸ Documentation Preview**.
2. Usa **Product ▸ Build Documentation** (⌃⇧⌘D) para abrirla en el visor.
3. Salta rápido a cualquier símbolo con **⇧⌘O**.

## Como sitio web

```bash
xcodebuild docbuild -scheme Signalist -destination 'platform=macOS' \
  -derivedDataPath build
# El archivo .doccarchive queda en build/Build/Products/Debug/

$(xcrun --find docc) process-archive transform-for-static-hosting \
  build/Build/Products/Debug/Signalist.doccarchive \
  --output-path docs --hosting-base-path signalist
```

Sube `docs/` a GitHub Pages. `theme-settings.json` (verde estándar y tipografía del sistema) solo se aplica a la versión web, no al visor de Xcode.

## Convenciones de comentarios

Resumen en una línea, luego *Discussion*, un bloque ` ```swift ` de ejemplo y enlaces con doble acento grave (por ejemplo ``MorseCode``).
