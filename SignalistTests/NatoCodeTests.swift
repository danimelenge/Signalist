import XCTest
@testable import Signalist

final class NatoCodeTests: XCTestCase {

    func testEncodeLetters() {
        XCTAssertEqual(NatoCode.encode("sos"), "Sierra Oscar Sierra")
    }

    func testEncodeIsCaseInsensitive() {
        XCTAssertEqual(NatoCode.encode("SOS"), NatoCode.encode("sos"))
    }

    func testEncodeDigits() {
        XCTAssertEqual(NatoCode.encode("A1"), "Alfa One")
    }

    func testEncodeSpaceBecomesSlash() {
        XCTAssertEqual(NatoCode.encode("a b"), "Alfa / Bravo")
    }

    func testEncodeOmitsUnsupportedCharacters() {
        XCTAssertEqual(NatoCode.encode("a#"), "Alfa")
    }

    func testDecodeWords() {
        XCTAssertEqual(NatoCode.decode("Sierra Oscar Sierra"), "sos")
        XCTAssertEqual(NatoCode.decode("alfa / bravo"), "a b")
    }

    func testDecodeIsCaseInsensitive() {
        XCTAssertEqual(NatoCode.decode("ALFA bravo"), "ab")
    }

    func testDecodeOmitsUnknownWords() {
        XCTAssertEqual(NatoCode.decode("Alfa Foo Bravo"), "ab")
    }

    func testXRayWithHyphenRoundTrips() {
        XCTAssertEqual(NatoCode.encode("x"), "X-ray")
        XCTAssertEqual(NatoCode.decode("X-ray"), "x")
    }

    func testEveryLetterAndDigitRoundTrips() {
        for (character, word) in NatoCode.letterDictionary {
            XCTAssertEqual(NatoCode.decode(word), String(character))
        }
        for (character, word) in NatoCode.digitDictionary {
            XCTAssertEqual(NatoCode.decode(word), String(character))
        }
    }
}
