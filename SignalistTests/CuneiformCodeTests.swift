import XCTest
@testable import Signalist

final class CuneiformCodeTests: XCTestCase {

    func testEncodeLettersAreSeparatedBySpaces() {
        XCTAssertEqual(CuneiformCode.encode("ab"), "\u{12000} \u{12001}")
    }

    func testEncodeSpaceBecomesSlash() {
        XCTAssertEqual(CuneiformCode.encode("a b"), "\u{12000} / \u{12001}")
    }

    func testEncodeIsCaseInsensitive() {
        XCTAssertEqual(CuneiformCode.encode("AB"), CuneiformCode.encode("ab"))
    }

    func testEncodeOmitsNumbersAndAccents() {
        XCTAssertEqual(CuneiformCode.encode("a1é b"), "\u{12000} / \u{12001}")
    }

    func testDecodeOmitsUnknownTokens() {
        XCTAssertEqual(CuneiformCode.decode("\u{12000} X \u{12001}"), "ab")
    }

    func testEveryLetterRoundTrips() {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        XCTAssertEqual(CuneiformCode.decode(CuneiformCode.encode(alphabet)), alphabet)
    }

    func testPhraseRoundTrip() {
        XCTAssertEqual(CuneiformCode.decode(CuneiformCode.encode("hola mundo")), "hola mundo")
    }
}
