import XCTest
@testable import Signalist

final class CaesarCodeTests: XCTestCase {

    func testEncodeShiftThree() {
        XCTAssertEqual(CaesarCode.encode("Hola", shift: 3), "Krod")
    }

    func testDecodeShiftThree() {
        XCTAssertEqual(CaesarCode.decode("Krod", shift: 3), "Hola")
    }

    func testWrapsAroundTheAlphabet() {
        XCTAssertEqual(CaesarCode.encode("xyz", shift: 3), "abc")
        XCTAssertEqual(CaesarCode.encode("Zz", shift: 1), "Aa")
    }

    func testNegativeShift() {
        XCTAssertEqual(CaesarCode.encode("abc", shift: -3), "xyz")
    }

    func testShiftOf26IsIdentity() {
        XCTAssertEqual(CaesarCode.encode("Hola", shift: 26), "Hola")
    }

    func testShiftLargerThan26IsReduced() {
        XCTAssertEqual(CaesarCode.encode("Hola", shift: 29), CaesarCode.encode("Hola", shift: 3))
    }

    func testNonLettersAreUntouched() {
        XCTAssertEqual(CaesarCode.encode("Hola, 123!", shift: 3), "Krod, 123!")
        XCTAssertEqual(CaesarCode.encode("ñ", shift: 5), "ñ")
    }

    func testRoundTripForEveryShift() {
        let text = "Hello, World! 2026"
        for shift in -30...30 {
            let encoded = CaesarCode.encode(text, shift: shift)
            XCTAssertEqual(CaesarCode.decode(encoded, shift: shift), text, "Falló con shift \(shift)")
        }
    }
}
