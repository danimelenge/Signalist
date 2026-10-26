import XCTest
@testable import Signalist

final class MorseCodeTests: XCTestCase {

    func testEncodeSOS() {
        XCTAssertEqual(MorseCode.encode("SOS"), "... --- ...")
    }

    func testEncodeSeparatesWordsWithSlash() {
        XCTAssertEqual(MorseCode.encode("HOLA MUNDO"), ".... --- .-.. .- / -- ..- -. -.. ---")
    }

    func testEncodeIsCaseInsensitive() {
        XCTAssertEqual(MorseCode.encode("Hola"), MorseCode.encode("hOLA"))
    }

    func testEncodeDigits() {
        XCTAssertEqual(MorseCode.encode("123"), ".---- ..--- ...--")
    }

    func testEncodeOmitsUnsupportedCharacters() {
        XCTAssertEqual(MorseCode.encode("a#b"), ".- -...")
    }

    func testDecodeSOS() {
        XCTAssertEqual(MorseCode.decode("... --- ..."), "sos")
    }

    func testDecodeWords() {
        XCTAssertEqual(MorseCode.decode(".... --- .-.. .- / -- ..- -. -.. ---"), "hola mundo")
    }

    func testDecodeIgnoresUnknownSequences() {
        XCTAssertEqual(MorseCode.decode(".- ........ -..."), "ab")
    }

    func testEmptyInput() {
        XCTAssertEqual(MorseCode.encode(""), "")
        XCTAssertEqual(MorseCode.decode(""), "")
    }

    func testEveryDictionaryEntryRoundTrips() {
        for (character, code) in MorseCode.dictionary {
            XCTAssertEqual(MorseCode.decode(code), String(character), "Falló con \(character)")
        }
    }
}
