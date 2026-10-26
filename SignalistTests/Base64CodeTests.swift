import XCTest
@testable import Signalist

final class Base64CodeTests: XCTestCase {

    func testEncodeHola() {
        XCTAssertEqual(Base64Code.encode("Hola"), "SG9sYQ==")
    }

    func testEncodeSentence() {
        XCTAssertEqual(Base64Code.encode("Hello, World!"), "SGVsbG8sIFdvcmxkIQ==")
    }

    func testDecodeHola() {
        XCTAssertEqual(Base64Code.decode("SG9sYQ=="), "Hola")
    }

    func testDecodeTrimsWhitespaceAndNewlines() {
        XCTAssertEqual(Base64Code.decode("  SG9sYQ==\n"), "Hola")
    }

    func testDecodeInvalidUTF8ReturnsEmpty() {
        // "/w==" son los bytes [0xFF], que no son UTF-8 válido.
        XCTAssertEqual(Base64Code.decode("/w=="), "")
    }

    func testEmptyInput() {
        XCTAssertEqual(Base64Code.encode(""), "")
        XCTAssertEqual(Base64Code.decode(""), "")
    }

    func testUnicodeRoundTrip() {
        let text = "Canción ñandú 😀"
        XCTAssertEqual(Base64Code.decode(Base64Code.encode(text)), text)
    }
}
