import XCTest
@testable import Signalist

final class RuneCodeTests: XCTestCase {

    func testEncodeHola() {
        XCTAssertEqual(RuneCode.encode("hola"), "\u{16BA}\u{16DF}\u{16DA}\u{16A8}")
    }

    func testEncodeSpaceUsesRunicDivider() {
        XCTAssertEqual(RuneCode.encode("a b"), "\u{16A8}\u{16EB}\u{16D2}")
    }

    func testEncodeIsCaseInsensitive() {
        XCTAssertEqual(RuneCode.encode("HOLA"), RuneCode.encode("hola"))
    }

    func testEncodeOmitsNumbersAndAccents() {
        XCTAssertEqual(RuneCode.encode("a1é"), "\u{16A8}")
    }

    func testDecodeAcceptsRunicDividerAndRegularSpace() {
        XCTAssertEqual(RuneCode.decode("\u{16A8}\u{16EB}\u{16D2}"), "a b")
        XCTAssertEqual(RuneCode.decode("\u{16A8} \u{16D2}"), "a b")
    }

    func testPhraseRoundTrip() {
        XCTAssertEqual(RuneCode.decode(RuneCode.encode("hola mundo")), "hola mundo")
    }

    /// Regresión: decodificar antes se caía porque varias letras comparten runa.
    func testDecodingSharedSymbolsDoesNotCrashAndUsesTheOriginalLetter() {
        XCTAssertEqual(RuneCode.decode(RuneCode.encode("cqvxy")), "kkwzj")
    }
}
