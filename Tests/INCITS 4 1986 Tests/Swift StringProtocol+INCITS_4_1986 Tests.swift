import Testing

import ASCII
import Byte
import Standard_Library_Extensions
@testable import INCITS_4_1986

@Suite
struct `StringProtocol exposes INCITS views and core ASCII conversions` {
    @Suite
    struct `Strings and substrings expose the ASCII view` {
        @Test
        func `String has static ascii property`() {
            #expect(String.ascii.lf == "\n")
            #expect(String.ascii.cr == "\r")
            #expect(String.ascii.crlf == "\r\n")
        }

        @Test
        func `Substring has static ascii property`() {
            #expect(Substring.ascii.lf == "\n")
            #expect(Substring.ascii.cr == "\r")
            #expect(Substring.ascii.crlf == "\r\n")
        }

        @Test
        func `String instance has ascii property`() {
            let str = "Hello"
            #expect(str.ascii.isAllASCII)
        }

        @Test
        func `Substring instance has ascii property`() {
            let str = "Hello World"
            let sub = str[str.startIndex..<str.index(str.startIndex, offsetBy: 5)]
            #expect(sub.ascii.isAllASCII)
        }
    }

    @Suite
    struct `String views delegate classification and detection to INCITS` {
        @Test
        func `String delegates isAllASCII to StringClassification`() {
            #expect(
                "Hello".ascii.isAllASCII == INCITS_4_1986.Text.Classification.isAllASCII("Hello")
            )
            #expect("café".ascii.isAllASCII == INCITS_4_1986.Text.Classification.isAllASCII("café"))
        }

        @Test
        func `Substring delegates isAllASCII to StringClassification`() {
            let str = "Hello World"
            let sub = str[str.startIndex..<str.index(str.startIndex, offsetBy: 5)]
            #expect(sub.ascii.isAllASCII == INCITS_4_1986.Text.Classification.isAllASCII(sub))
        }

        @Test
        func `String delegates detectedLineEnding to LineEndingDetection`() {
            let str = "line1\r\nline2"
            #expect(
                str.ascii.detectedLineEnding() == INCITS_4_1986.LineEnding.Detection.detect(str)
            )
        }

        @Test
        func `Substring delegates detectedLineEnding to LineEndingDetection`() {
            let str = "line1\r\nline2"
            let sub = str[...]
            #expect(
                sub.ascii.detectedLineEnding() == INCITS_4_1986.LineEnding.Detection.detect(sub)
            )
        }
    }

    @Suite
    struct `Case conversion maps ASCII letters to the requested case` {
        @Test
        func `ASCII case conversion method works for String`() {
            #expect("Hello".ascii(case: .upper) == "HELLO")
            #expect("Hello".ascii(case: .lower) == "hello")
        }

        @Test
        func `ASCII case conversion method works for Substring`() {
            let str = "Hello World"
            let sub = str[str.startIndex..<str.index(str.startIndex, offsetBy: 5)]
            #expect(sub.ascii(case: .upper) == "HELLO")
            #expect(sub.ascii(case: .lower) == "hello")
        }

        @Test
        func `The uppercased convenience method produces uppercase letters`() {
            #expect("Hello".ascii.uppercased() == "HELLO")
        }

        @Test
        func `The lowercased convenience method produces lowercase letters`() {
            #expect("Hello".ascii.lowercased() == "hello")
        }
    }

    @Suite
    struct `String initialization produces the requested line ending` {
        @Test
        func `Line ending initialization creates correct string for LF`() {
            #expect(String(ascii: .lf) == "\n")
        }

        @Test
        func `Line ending initialization creates correct string for CR`() {
            #expect(String(ascii: .cr) == "\r")
        }

        @Test
        func `Line ending initialization creates correct string for CRLF`() {
            #expect(String(ascii: .crlf) == "\r\n")
        }
    }

    @Suite
    struct `String initialization validates ASCII bytes` {
        @Test
        func `ASCII initialization creates string from valid ASCII bytes`() {
            let codes: [ASCII.Code] = [.H, .e, .l, .l, .o]
            #expect(String(ascii: codes) == "Hello")
        }

        @Test
        func `ASCII initialization returns nil for non-ASCII bytes`() {

            let bytes: [Byte] = [0x48, 0x65, 0xFF, 0x6C, 0x6F]
            #expect(String(ascii: bytes) == nil)
        }

        @Test
        func `Unchecked ASCII decoding creates string without validation`() {

            let codes: [ASCII.Code] = [.H, .e, .l, .l, .o]
            #expect(String.ascii.unchecked(codes.map(\.underlying)) == "Hello")
        }
    }

    @Suite
    struct `Strings and substrings normalize their line endings` {
        @Test
        func `Normalization normalizes line endings`() {
            let str = "line1\nline2\r\nline3\rline4"
            #expect(str.normalized(to: .lf) == "line1\nline2\nline3\nline4")
            #expect(str.normalized(to: .cr) == "line1\rline2\rline3\rline4")
            #expect(str.normalized(to: .crlf) == "line1\r\nline2\r\nline3\r\nline4")
        }

        @Test
        func `Normalization works for Substring`() {
            let str = "line1\nline2"
            let sub = str[...]
            #expect(sub.normalized(to: .crlf) == "line1\r\nline2")
        }
    }

    @Suite
    struct `Strings and substrings trim the requested characters` {
        @Test
        func `Trimming removes characters from both ends`() {
            let str = "  hello  "
            #expect(str.trimming(Set<Character>.ascii.whitespaces) == "hello")
        }

        @Test
        func `Trimming works for Substring`() {
            let str = "  hello  "
            let sub = str[...]
            #expect(String(sub.trimming(Set<Character>.ascii.whitespaces)) == "hello")
        }
    }
}
