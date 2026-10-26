import XCTest
@testable import Signalist

/// Pruebas que cruzan varios conversores a la vez.
final class SignalistTests: XCTestCase {

    /// Los conversores de texto a símbolos deben devolver el texto original
    /// (en minúsculas) para una frase sencilla.
    func testLetterCiphersRoundTripASimplePhrase() {
        let phrase = "hola mundo"
        let pairs: [(String, (String) -> String, (String) -> String)] = [
            ("Morse", MorseCode.encode, MorseCode.decode),
            ("NATO", NatoCode.encode, NatoCode.decode),
            ("Cuneiforme", CuneiformCode.encode, CuneiformCode.decode),
            ("Jeroglíficos", HieroglyphCode.encode, HieroglyphCode.decode),
            ("Runas", RuneCode.encode, RuneCode.decode),
            ("Ogham", OghamCode.encode, OghamCode.decode),
            ("Semáforo", SemaphoreCode.encode, SemaphoreCode.decode)
        ]
        for (name, encode, decode) in pairs {
            XCTAssertEqual(decode(encode(phrase)), phrase, "Falló \(name)")
        }
    }

    /// Los conversores binarios deben soportar texto con acentos y emojis.
    func testByteBasedCodesRoundTripUnicodeText() {
        let text = "Canción ñandú 😀"
        XCTAssertEqual(AsciiCode.decode(AsciiCode.encode(text)), text)
        XCTAssertEqual(BinaryCode.decode(BinaryCode.encode(text)), text)
        XCTAssertEqual(Base64Code.decode(Base64Code.encode(text)), text)
        XCTAssertEqual(UnicodeCode.decode(UnicodeCode.encode(text)), text)
    }

    /// Los modos de conversión se usan en un `Picker`, así que sus ids deben ser únicos.
    func testConversionModesHaveUniqueIDs() {
        assertUniqueIDs(ConversionMode.self)
        assertUniqueIDs(AsciiConversionMode.self)
        assertUniqueIDs(Base64ConversionMode.self)
        assertUniqueIDs(BinaryConversionMode.self)
        assertUniqueIDs(BrailleConversionMode.self)
        assertUniqueIDs(CaesarConversionMode.self)
        assertUniqueIDs(CuneiformConversionMode.self)
        assertUniqueIDs(HieroglyphConversionMode.self)
        assertUniqueIDs(MayaConversionMode.self)
        assertUniqueIDs(NatoConversionMode.self)
        assertUniqueIDs(OghamConversionMode.self)
        assertUniqueIDs(Rot13ConversionMode.self)
        assertUniqueIDs(Rot47ConversionMode.self)
        assertUniqueIDs(RuneConversionMode.self)
        assertUniqueIDs(SemaphoreConversionMode.self)
        assertUniqueIDs(UnicodeConversionMode.self)
    }

    private func assertUniqueIDs<T: CaseIterable & Identifiable>(
        _ type: T.Type,
        file: StaticString = #filePath,
        line: UInt = #line
    ) where T.ID: Hashable {
        let ids = type.allCases.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "ids repetidos en \(type)", file: file, line: line)
    }
}
