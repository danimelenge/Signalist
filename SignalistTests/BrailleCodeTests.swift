import XCTest
@testable import Signalist

final class BrailleCodeTests: XCTestCase {

    func testEncodeLowercase() {
        XCTAssertEqual(BrailleCode.encode("hola"), "⠓⠕⠇⠁")
    }

    func testEncodeCapitalLetterUsesCapitalSign() {
        XCTAssertEqual(BrailleCode.encode("Hola"), "⠠⠓⠕⠇⠁")
    }

    func testEncodeNumbersUseNumberSignOnce() {
        XCTAssertEqual(BrailleCode.encode("123"), "⠼⠁⠃⠉")
    }

    func testEncodeSpaceUsesBrailleSpaceAndResetsNumberMode() {
        XCTAssertEqual(BrailleCode.encode("a 1"), "⠁\u{2800}⠼⠁")
    }

    func testEncodePunctuation() {
        XCTAssertEqual(BrailleCode.encode("hi!"), "⠓⠊⠖")
    }

    func testEncodeOmitsUnsupportedCharacters() {
        XCTAssertEqual(BrailleCode.encode("#"), "")
    }

    func testDecode() {
        XCTAssertEqual(BrailleCode.decode("⠠⠓⠕⠇⠁"), "Hola")
        XCTAssertEqual(BrailleCode.decode("⠼⠁⠃⠉"), "123")
    }

    func testRoundTrip() {
        let text = "Hola Mundo 2026!"
        XCTAssertEqual(BrailleCode.decode(BrailleCode.encode(text)), text)
    }

    func testEveryLetterRoundTrips() {
        for letter in "abcdefghijklmnopqrstuvwxyz" {
            let text = String(letter)
            XCTAssertEqual(BrailleCode.decode(BrailleCode.encode(text)), text)
        }
    }
}
