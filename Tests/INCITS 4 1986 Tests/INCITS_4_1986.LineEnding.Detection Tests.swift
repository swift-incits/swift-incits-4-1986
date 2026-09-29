import Testing

@testable import INCITS_4_1986

extension INCITS_4_1986.LineEnding.Detection {
    @Suite struct `INCITS detects line ending styles and mixtures` {
        @Suite struct `INCITS line ending detection provides its declared operations` {
            @Test func `Detect identifies LF only text`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("line1\nline2") == .lf)
            }

            @Test func `Detect identifies CR only text`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("line1\rline2") == .cr)
            }

            @Test func `Detect identifies CRLF text`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("line1\r\nline2") == .crlf)
            }

            @Test func `Detect returns nil when no line endings are present`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("no line endings") == nil)
            }

            @Test func `HasMixedLineEndings is false for a single consistent style`() {
                #expect(
                    !INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("line1\nline2\nline3")
                )
                #expect(
                    !INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings(
                        "line1\r\nline2\r\nline3"
                    )
                )
            }

            @Test func `HasMixedLineEndings is true when multiple styles are present`() {
                #expect(
                    INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("line1\nline2\r\nline3")
                )
                #expect(
                    INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("line1\rline2\nline3")
                )
            }
        }

        @Suite struct `INCITS line ending detection handles empty inputs and boundary values` {
            @Test func `Detect on an empty string returns nil`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("") == nil)
            }

            @Test func `Detect prioritizes CRLF when CR is immediately followed by LF`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("\r\n") == .crlf)
            }

            @Test func `Detect treats a trailing standalone CR as CR not CRLF`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("line1\r") == .cr)
            }

            @Test func `HasMixedLineEndings is false on an empty string`() {
                #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings(""))
            }

            @Test func `HasMixedLineEndings is false for a single line ending occurrence`() {
                #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("\n"))
            }

            @Test func `HasMixedLineEndings treats repeated CRLF as one style not two`() {
                #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("a\r\nb\r\nc\r\n"))
            }
        }

        @Suite struct `INCITS line ending detection integrates with its consumers` {}
    }
}
