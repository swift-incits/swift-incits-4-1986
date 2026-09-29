import Testing

import ASCII
import Byte
import Standard_Library_Extensions
@testable import INCITS_4_1986

@Suite
struct `Line ending styles produce the specified ASCII sequences` {
    @Suite
    struct `Line ending constants convert consistently to strings and codes` {
        @Test(arguments: [
            (INCITS_4_1986.FormatEffectors.Line.Ending.lf, "LF", [ASCII.Code.lf]),
            (INCITS_4_1986.FormatEffectors.Line.Ending.cr, "CR", [ASCII.Code.cr]),
            (
                INCITS_4_1986.FormatEffectors.Line.Ending.crlf, "CRLF",
                [ASCII.Code.cr, ASCII.Code.lf]
            ),
        ])
        func `Line ending styles produce the specified code sequences`(
            ending: INCITS_4_1986.FormatEffectors.Line.Ending,
            name: String,
            expected: [ASCII.Code]
        ) {
            #expect([ASCII.Code](ascii: ending) == expected, "\(name) should produce correct codes")
        }

        @Test(arguments: [
            (INCITS_4_1986.FormatEffectors.Line.Ending.lf, "\n"),
            (INCITS_4_1986.FormatEffectors.Line.Ending.cr, "\r"),
            (INCITS_4_1986.FormatEffectors.Line.Ending.crlf, "\r\n"),
        ])
        func `Line ending styles produce the specified strings`(
            ending: INCITS_4_1986.FormatEffectors.Line.Ending,
            expected: String
        ) {
            #expect(String(ascii: ending) == expected)
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
