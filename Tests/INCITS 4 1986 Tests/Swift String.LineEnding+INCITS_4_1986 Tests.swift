import ASCII
import Byte
import Standard_Library_Extensions
import Testing

@testable import INCITS_4_1986

@Suite
struct `Line ending styles produce the specified ASCII sequences` {
    @Suite
    struct `Line ending constants convert consistently to strings and codes` {
        @Test
        func `Line ending styles produce the specified code sequences`() {
            let cases: [(INCITS_4_1986.FormatEffectors.Line.Ending, String, [ASCII.Code])] = [
                (.lf, "LF", [ASCII.Code.lf]),
                (.cr, "CR", [ASCII.Code.cr]),
                (.crlf, "CRLF", [ASCII.Code.cr, ASCII.Code.lf]),
            ]
            for (ending, name, expected) in cases {
                #expect([ASCII.Code](ascii: ending) == expected, "\(name) should produce correct codes")
            }
        }

        @Test
        func `Line ending styles produce the specified strings`() {
            let cases: [(INCITS_4_1986.FormatEffectors.Line.Ending, String)] = [
                (.lf, "\n"),
                (.cr, "\r"),
                (.crlf, "\r\n"),
            ]
            for (ending, expected) in cases {
                #expect(String(ascii: ending) == expected)
            }
        }

        @Test
        func `Line ending strings agree with conversion through codes`() {
            for ending in [INCITS_4_1986.FormatEffectors.Line.Ending.lf, .cr, .crlf] {
                let codes = [ASCII.Code](ascii: ending)
                let string = String(ascii: codes)
                let expectedString = String(ascii: ending)
                #expect(string == expectedString)
            }
        }
    }
}
