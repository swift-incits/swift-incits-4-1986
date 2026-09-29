import Testing

import ASCII
import Byte
import Standard_Library_Extensions
@testable import INCITS_4_1986

@Suite
struct `Format effectors normalize ASCII line endings` {
    @Suite
    struct `Line ending normalization preserves text content` {
        @Test
        func `Normalization converts each line ending to the requested style`() {
            let cases: [(String, INCITS_4_1986.FormatEffectors.Line.Ending, String)] = [
                ("hello\nworld", .lf, "hello\nworld"),
                ("hello\nworld", .cr, "hello\rworld"),
                ("hello\nworld", .crlf, "hello\r\nworld"),
                ("hello\r\nworld", .lf, "hello\nworld"),
                ("hello\rworld", .lf, "hello\nworld"),
            ]
            for (input, to, expected) in cases {
                #expect(input.normalized(to: to) == expected)
            }
        }

        @Test
        func `Normalization preserves content`() {
            let text = "Line 1\nLine 2\r\nLine 3\rEnd"
            let normalized = text.normalized(to: .lf)
            let lines = normalized.split(separator: "\n").map(String.init)
            #expect(lines == ["Line 1", "Line 2", "Line 3", "End"])
        }
    }

    @Suite
    struct `Repeated line ending normalization preserves the first result` {
        @Test
        func `Normalization is idempotent`() {
            let text = "hello\nworld\r\ntest\rend"
            for ending in [INCITS_4_1986.FormatEffectors.Line.Ending.lf, .cr, .crlf] {
                let first = text.normalized(to: ending)
                let second = first.normalized(to: ending)
                #expect(first == second, "Normalizing twice should be idempotent")
            }
        }

        @Test
        func `Normalization preserves text without line endings`() {
            let text = "no line endings here"
            for ending in [INCITS_4_1986.FormatEffectors.Line.Ending.lf, .cr, .crlf] {
                #expect(text.normalized(to: ending) == text)
            }
        }
    }
}
