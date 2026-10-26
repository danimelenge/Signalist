import XCTest
@testable import Signalist

final class BinaryCodeTests: XCTestCase {

    func testEncodeSingleCharacterIsPaddedTo8Bits() {
        XCTAssertEqual(BinaryCode.encode("A"), "01000001")
    }

    func testEncodeHola() {
        XCTAssertEqual(BinaryCode.encode("Hola"), "01001000 01101111 01101100 01100001")
    }

    func testDecodeHi() {
        XCTAssertEqual(BinaryCode.decode("01001000 01101001"), "Hi")
    }

    func testDecodeSkipsInvalidGroups() {
        // "012" no es binario y "100000001" no cabe en un byte.
        XCTAssertEqual(BinaryCode.decode("012 01001000 100000001"), "H")
    }

    func testEmptyInput() {
        XCTAssertEqual(BinaryCode.encode(""), "")
        XCTAssertEqual(BinaryCode.decode(""), "")
    }

    func testUTF8RoundTrip() {
        let text = "Canción ñ 😀"
        XCTAssertEqual(BinaryCode.decode(BinaryCode.encode(text)), text)
    }
}
