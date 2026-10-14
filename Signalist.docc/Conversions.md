# Conversiones disponibles

Las 16 pestañas de Signalist, con un ejemplo comprobado de cada una.

@Metadata {
    @PageColor(blue)
}

## Códigos reales

| Pestaña | Entrada | Salida |
|---|---|---|
| Morse | `SOS` | `... --- ...` |
| Morse | `HOLA MUNDO` | `.... --- .-.. .- / -- ..- -. -.. ---` |
| Binario | `A` | `01000001` |
| ASCII | `Hola` | `72 111 108 97` |
| Unicode | `Hola` | `U+0048 U+006F U+006C U+0061` |
| Base64 | `Hola` | `SG9sYQ==` |
| César (desplazamiento 3) | `Hola` | `Krod` |
| ROT13 | `Hola` | `Ubyn` |
| ROT47 | `Hola123!` | ``w@=2`abP`` |

Braille, NATO, Semáforo, Runas (Elder Futhark) y Ogham completan el resto de transliteraciones reales.

## Aclaraciones de honestidad

- **Jeroglíficos** y **Cuneiforme** son *cifrados creativos*, no una transliteración académica.
- **Runas** y **Ogham** son transliteraciones reales con letras aproximadas.
- **Maya** convierte solo números (base 20); la escritura glífica maya no está en Unicode. Ejemplo: `2026` = 5·400 + 1·20 + 6.
- Los glifos mayas se dibujan con formas de SwiftUI porque ninguna fuente del sistema cubre ese bloque.

## See Also

- ``MayaCode``
- ``CaesarCode``
