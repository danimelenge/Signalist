import XCTest
@testable import Signalist

final class AsciiCodeTests: XCTestCase {

    func testEncodeHola() {
        XCTAssertEqual(AsciiCode.encode("Hola"), "72 111 108 97")
    }

    func testEncodeSingleCharacter() {
        XCTAssertEqual(AsciiCode.encode("A"), "65")
    }

    func testDecodeHola() {
        XCTAssertEqual(AsciiCode.decode("72 111 108 97"), "Hola")
    }

    func testDecodeToleratesExtraSpaces() {
        XCTAssertEqual(AsciiCode.decode("72   105"), "Hi")
    }

    func testDecodeSkipsInvalidAndOutOfRangeValues() {
        XCTAssertEqual(AsciiCode.decode("abc 72 300 105"), "Hi")
    }

    func testEmptyInput() {
        XCTAssertEqual(AsciiCode.encode(""), "")
        XCTAssertEqual(AsciiCode.decode(""), "")
    }

    func testUTF8RoundTrip() {
        let text = "Canción ñ 😀"
        XCTAssertEqual(AsciiCode.decode(AsciiCode.encode(text)), text)
    }
}
