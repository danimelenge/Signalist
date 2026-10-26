import XCTest
@testable import Signalist

final class Rot47CodeTests: XCTestCase {

    func testEncodeHola() {
        XCTAssertEqual(Rot47Code.encode("Hola"), "w@=2")
    }

    func testEncodeLettersDigitsAndSymbols() {
        XCTAssertEqual(Rot47Code.encode("Hola123!"), "w@=2`abP")
    }

    func testDecodeHola() {
        XCTAssertEqual(Rot47Code.decode("w@=2"), "Hola")
    }

    func testSpacesAreUntouched() {
        XCTAssertEqual(Rot47Code.encode("Hola Hola"), "w@=2 w@=2")
    }

    func testAccentsAndEmojiAreUntouched() {
        XCTAssertEqual(Rot47Code.encode("ñ 😀"), "ñ 😀")
    }

    func testEveryPrintableASCIICharacterRoundTrips() {
        let printable = String((33...126).map { Character(UnicodeScalar($0)!) })
        XCTAssertEqual(Rot47Code.decode(Rot47Code.encode(printable)), printable)
    }
}
