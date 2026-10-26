import XCTest
@testable import Signalist

final class SemaphoreCodeTests: XCTestCase {

    func testEncodeSingleLetter() {
        XCTAssertEqual(SemaphoreCode.encode("a"), "↘↓")
    }

    func testEncodeSOS() {
        XCTAssertEqual(SemaphoreCode.encode("sos"), "→↙ →↗ →↙")
    }

    func testEncodeSpaceBecomesSlash() {
        XCTAssertEqual(SemaphoreCode.encode("a b"), "↘↓ / →↓")
    }

    func testEncodeIsCaseInsensitive() {
        XCTAssertEqual(SemaphoreCode.encode("SOS"), SemaphoreCode.encode("sos"))
    }

    func testEncodeOmitsNumbersAndAccents() {
        XCTAssertEqual(SemaphoreCode.encode("a1é"), "↘↓")
    }

    func testDecode() {
        XCTAssertEqual(SemaphoreCode.decode("→↙ →↗ →↙"), "sos")
        XCTAssertEqual(SemaphoreCode.decode("↘↓ / →↓"), "a b")
    }

    func testDecodeOmitsUnknownTokens() {
        XCTAssertEqual(SemaphoreCode.decode("↘↓ ?? →↓"), "ab")
    }

    func testEveryLetterHasADistinctPositionAndRoundTrips() {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        XCTAssertEqual(SemaphoreCode.decode(SemaphoreCode.encode(alphabet)), alphabet)
    }
}
