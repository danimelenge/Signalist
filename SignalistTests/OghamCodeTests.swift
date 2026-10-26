import XCTest
@testable import Signalist

final class OghamCodeTests: XCTestCase {

    func testEncodeHola() {
        XCTAssertEqual(OghamCode.encode("hola"), "\u{1686}\u{1691}\u{1682}\u{1690}")
    }

    func testEncodeSpaceUsesOghamSpaceMark() {
        XCTAssertEqual(OghamCode.encode("a b"), "\u{1690}\u{1680}\u{1681}")
    }

    func testEncodeIsCaseInsensitive() {
        XCTAssertEqual(OghamCode.encode("HOLA"), OghamCode.encode("hola"))
    }

    func testEncodeOmitsNumbersAndAccents() {
        XCTAssertEqual(OghamCode.encode("a1é"), "\u{1690}")
    }

    func testDecodeAcceptsOghamSpaceMarkAndRegularSpace() {
        XCTAssertEqual(OghamCode.decode("\u{1690}\u{1680}\u{1681}"), "a b")
        XCTAssertEqual(OghamCode.decode("\u{1690} \u{1681}"), "a b")
    }

    func testPhraseRoundTrip() {
        XCTAssertEqual(OghamCode.decode(OghamCode.encode("hola mundo")), "hola mundo")
    }

    /// Regresión: decodificar antes se caía porque varias letras comparten trazo.
    func testDecodingSharedSymbolsDoesNotCrashAndUsesTheOriginalLetter() {
        XCTAssertEqual(OghamCode.decode(OghamCode.encode("kwvxyj")), "cufzii")
    }
}
