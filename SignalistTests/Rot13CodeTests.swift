import XCTest
@testable import Signalist

final class Rot13CodeTests: XCTestCase {

    func testEncodeHola() {
        XCTAssertEqual(Rot13Code.encode("Hola"), "Ubyn")
    }

    func testEncodeSentence() {
        XCTAssertEqual(Rot13Code.encode("Hello, World!"), "Uryyb, Jbeyq!")
    }

    func testDecodeIsTheSameOperation() {
        XCTAssertEqual(Rot13Code.decode("Ubyn"), "Hola")
        XCTAssertEqual(Rot13Code.decode("Hello"), Rot13Code.encode("Hello"))
    }

    func testAppliedTwiceIsIdentity() {
        let text = "The Quick Brown Fox, 2026!"
        XCTAssertEqual(Rot13Code.encode(Rot13Code.encode(text)), text)
    }

    func testDigitsAccentsAndEmojiAreUntouched() {
        XCTAssertEqual(Rot13Code.encode("123 ñ é 😀"), "123 ñ é 😀")
    }
}
