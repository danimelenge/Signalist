import XCTest
@testable import Signalist

final class MayaCodeTests: XCTestCase {

    func testEncodeZero() {
        XCTAssertEqual(MayaCode.encode("0"), "\u{1D2E0}")
    }

    func testEncodeBiggestSingleDigit() {
        XCTAssertEqual(MayaCode.encode("19"), "\u{1D2F3}")
    }

    func testEncodeTwentyNeedsTwoPlaces() {
        XCTAssertEqual(MayaCode.encode("20"), "\u{1D2E1} \u{1D2E0}")
    }

    /// 2026 = 5·400 + 1·20 + 6
    func testEncode2026() {
        XCTAssertEqual(MayaCode.encode("2026"), "\u{1D2E5} \u{1D2E1} \u{1D2E6}")
    }

    func testEncodeSeveralNumbersSeparatedBySlash() {
        XCTAssertEqual(MayaCode.encode("7 y 20"), "\u{1D2E7} / \u{1D2E1} \u{1D2E0}")
    }

    func testEncodeTextWithoutDigitsIsEmpty() {
        XCTAssertEqual(MayaCode.encode("hola"), "")
    }

    func testEncodeOmitsNumbersTooLargeForUInt64() {
        XCTAssertEqual(MayaCode.encode("99999999999999999999"), "")
    }

    func testDecode2026() {
        XCTAssertEqual(MayaCode.decode("\u{1D2E5} \u{1D2E1} \u{1D2E6}"), "2026")
    }

    func testDecodeSeveralNumbersJoinsWithCommas() {
        XCTAssertEqual(MayaCode.decode("\u{1D2E7} / \u{1D2E1} \u{1D2E0}"), "7, 20")
    }

    func testDecodeWithoutMayaDigitsIsEmpty() {
        XCTAssertEqual(MayaCode.decode("hola"), "")
    }

    func testDigitGroups() {
        XCTAssertEqual(MayaCode.digitGroups(in: MayaCode.encode("2026")), [[5, 1, 6]])
        XCTAssertEqual(MayaCode.digitGroups(in: MayaCode.encode("7 y 20")), [[7], [1, 0]])
    }

    func testRoundTrip() {
        for number in ["0", "1", "19", "20", "399", "400", "2026", "123456789"] {
            XCTAssertEqual(MayaCode.decode(MayaCode.encode(number)), number, "Falló con \(number)")
        }
    }
}
