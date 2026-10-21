import ASCII
import Byte
import Standard_Library_Extensions
import Testing

@testable import INCITS_4_1986

@Suite
struct `INCITS detects ASCII line ending styles` {

    @Suite
    struct `Detection identifies the preferred line ending style` {
        @Test(arguments: [
            "line1\nline2",
            "line1\n",
            "\n",
            "test\nmore\nlines",
        ])
        func `Line ending detection detects LF line endings`(str: String) {
            #expect(INCITS_4_1986.LineEnding.Detection.detect(str) == .lf)
        }

        @Test(arguments: [
            "line1\rline2",
            "line1\r",
            "\r",
            "test\rmore\rlines",
        ])
        func `Line ending detection detects CR line endings`(str: String) {
            #expect(INCITS_4_1986.LineEnding.Detection.detect(str) == .cr)
        }

        @Test(arguments: [
            "line1\r\nline2",
            "line1\r\n",
            "\r\n",
            "test\r\nmore\r\nlines",
        ])
        func `Line ending detection detects CRLF line endings`(str: String) {
            #expect(INCITS_4_1986.LineEnding.Detection.detect(str) == .crlf)
        }

        @Test(arguments: [
            "no line endings",
            "test",
            "",
            "hello world",
        ])
        func `Line ending detection returns nil when no line endings present`(str: String) {
            #expect(INCITS_4_1986.LineEnding.Detection.detect(str) == nil)
        }

        @Test
        func `Line ending detection prioritizes CRLF over individual CR or LF`() {

            #expect(INCITS_4_1986.LineEnding.Detection.detect("test\r\nmore") == .crlf)
        }
    }

    @Suite
    struct `Mixed line ending detection distinguishes standalone and paired controls` {
        @Test(arguments: [
            "line1\nline2\nline3",
            "line1\rline2\rline3",
            "line1\r\nline2\r\nline3",
            "no line endings",
            "",
        ])
        func `Line ending detection returns false for consistent or no line endings`(str: String) {
            #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings(str))
        }

        @Test(arguments: [
            "line1\nline2\r\nline3",
            "line1\rline2\nline3",
            "line1\rline2\r\nline3",
            "line1\nline2\rline3\r\n",
        ])
        func `Line ending detection returns true for mixed line endings`(str: String) {
            #expect(INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings(str))
        }

        @Test
        func `CRLF is distinct from standalone CR and LF`() {

            #expect(INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("line1\r\nline2\nline3"))

            #expect(INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("line1\r\nline2\rline3"))
        }

        @Test
        func `Consecutive CRLF is not mixed`() {
            #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("line1\r\nline2\r\n"))
            #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("\r\n\r\n"))
        }

        @Test
        func `CR not followed by LF is standalone`() {

            #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("line1\rline2\r"))
        }
    }

    @Suite
    struct `Line ending detection handles empty and consecutive controls` {
        @Test
        func `Empty string has no line endings`() {
            #expect(INCITS_4_1986.LineEnding.Detection.detect("") == nil)
            #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings(""))
        }

        @Test
        func `Detection recognizes a single LF`() {
            #expect(INCITS_4_1986.LineEnding.Detection.detect("\n") == .lf)
        }

        @Test
        func `Detection recognizes a single CR`() {
            #expect(INCITS_4_1986.LineEnding.Detection.detect("\r") == .cr)
        }

        @Test
        func `Detection recognizes a single CRLF`() {
            #expect(INCITS_4_1986.LineEnding.Detection.detect("\r\n") == .crlf)
        }

        @Test
        func `A line ending at the start is handled`() {
            #expect(INCITS_4_1986.LineEnding.Detection.detect("\ntest") == .lf)
            #expect(INCITS_4_1986.LineEnding.Detection.detect("\rtest") == .cr)
            #expect(INCITS_4_1986.LineEnding.Detection.detect("\r\ntest") == .crlf)
        }

        @Test
        func `A line ending at the end is handled`() {
            #expect(INCITS_4_1986.LineEnding.Detection.detect("test\n") == .lf)
            #expect(INCITS_4_1986.LineEnding.Detection.detect("test\r") == .cr)
            #expect(INCITS_4_1986.LineEnding.Detection.detect("test\r\n") == .crlf)
        }

        @Test
        func `Detection recognizes consecutive line endings`() {
            #expect(INCITS_4_1986.LineEnding.Detection.detect("\n\n") == .lf)
            #expect(INCITS_4_1986.LineEnding.Detection.detect("\r\r") == .cr)
            #expect(INCITS_4_1986.LineEnding.Detection.detect("\r\n\r\n") == .crlf)
        }

        @Test
        func `CR followed by non-LF is standalone CR`() {
            #expect(INCITS_4_1986.LineEnding.Detection.detect("\ra") == .cr)
            #expect(INCITS_4_1986.LineEnding.Detection.detect("test\r1") == .cr)
        }
    }

    @Suite
    struct `CRLF takes precedence over standalone line endings` {
        @Test
        func `CRLF takes precedence in detection`() {

            #expect(INCITS_4_1986.LineEnding.Detection.detect("test\r\n") == .crlf)
            #expect(INCITS_4_1986.LineEnding.Detection.detect("a\r\nb") == .crlf)
        }

        @Test
        func `Detection recognizes a CR without a following LF`() {

            #expect(INCITS_4_1986.LineEnding.Detection.detect("test\rmore") == .cr)
            #expect(INCITS_4_1986.LineEnding.Detection.detect("\r") == .cr)
        }

        @Test
        func `Detection recognizes an LF without a preceding CR`() {

            #expect(INCITS_4_1986.LineEnding.Detection.detect("test\nmore") == .lf)
            #expect(INCITS_4_1986.LineEnding.Detection.detect("\n") == .lf)
        }
    }

    @Suite
    struct `Line ending detection handles text from different platforms` {
        @Test
        func `Detection recognizes Unix line endings`() {
            let text = "#!/bin/bash\necho 'Hello'\necho 'World'\n"
            #expect(INCITS_4_1986.LineEnding.Detection.detect(text) == .lf)
            #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings(text))
        }

        @Test
        func `Detection recognizes Windows line endings`() {
            let text = "Line 1\r\nLine 2\r\nLine 3\r\n"
            #expect(INCITS_4_1986.LineEnding.Detection.detect(text) == .crlf)
            #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings(text))
        }

        @Test
        func `Detection recognizes classic Mac line endings`() {
            let text = "Line 1\rLine 2\rLine 3\r"
            #expect(INCITS_4_1986.LineEnding.Detection.detect(text) == .cr)
            #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings(text))
        }

        @Test
        func `Detection recognizes text with mixed platform line endings`() {
            let text = "Unix line\nWindows line\r\nMac line\r"
            #expect(INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings(text))
        }
    }
}
