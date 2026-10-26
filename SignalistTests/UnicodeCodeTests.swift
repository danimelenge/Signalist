import XCTest
@testable import Signalist

final class UnicodeCodeTests: XCTestCase {

    func testEncodeHola() {
        XCTAssertEqual(UnicodeCode.encode("Hola"), "U+0048 U+006F U+006C U+0061")
    }

    func testEncodePadsToFourDigits() {
        XCTAssertEqual(UnicodeCode.encode("\u{E9}"), "U+00E9")
    }

    func testEncodeEmojiUsesMoreThanFourDigits() {
        XCTAssertEqual(UnicodeCode.encode("😀"), "U+1F600")
    }

    func testDecodeWithPrefix() {
        XCTAssertEqual(UnicodeCode.decode("U+0048 U+0069"), "Hi")
    }

    func testDecodeWithoutPrefixAndLowercase() {
        XCTAssertEqual(UnicodeCode.decode("48 69"), "Hi")
        XCTAssertEqual(UnicodeCode.decode("u+0048 u+0069"), "Hi")
    }

    func testDecodeSkipsInvalidCodePoints() {
        // "ZZZZ" no es hexadecimal y U+D800 es un sustituto (no es un escalar válido).
        XCTAssertEqual(UnicodeCode.decode("U+ZZZZ U+0048 U+D800"), "H")
    }

    func testEmptyInput() {
        XCTAssertEqual(UnicodeCode.encode(""), "")
        XCTAssertEqual(UnicodeCode.decode(""), "")
    }

    func testRoundTrip() {
        let text = "Canción ñ 😀"
        XCTAssertEqual(UnicodeCode.decode(UnicodeCode.encode(text)), text)
    }
}
