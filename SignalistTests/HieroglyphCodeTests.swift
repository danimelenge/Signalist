import XCTest
@testable import Signalist

final class HieroglyphCodeTests: XCTestCase {

    func testEncodeLettersAreSeparatedBySpaces() {
        XCTAssertEqual(HieroglyphCode.encode("ab"), "\u{13000} \u{13001}")
    }

    func testEncodeSpaceBecomesSlash() {
        XCTAssertEqual(HieroglyphCode.encode("a b"), "\u{13000} / \u{13001}")
    }

    func testLastLettersUseTheSecondBlockRange() {
        XCTAssertEqual(HieroglyphCode.encode("xyz"), "\u{1306F} \u{13070} \u{13071}")
    }

    func testEncodeOmitsNumbersAndAccents() {
        XCTAssertEqual(HieroglyphCode.encode("a1é b"), "\u{13000} / \u{13001}")
    }

    func testDecodeOmitsUnknownTokens() {
        XCTAssertEqual(HieroglyphCode.decode("\u{13000} X \u{13001}"), "ab")
    }

    func testEveryLetterRoundTrips() {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        XCTAssertEqual(HieroglyphCode.decode(HieroglyphCode.encode(alphabet)), alphabet)
    }

    func testPhraseRoundTrip() {
        XCTAssertEqual(HieroglyphCode.decode(HieroglyphCode.encode("hola mundo")), "hola mundo")
    }
}
