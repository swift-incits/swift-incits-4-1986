import Testing

@testable import INCITS_4_1986

@Suite struct `INCITS views expose code and string operations` {
    @Suite struct `INCITS views provides its declared operations` {
        @Test func `Code collection isAllASCII is trivially true`() {
            let codes = [ASCII::ASCII.Code](ascii: "hello")!
            #expect(codes.ascii.isAllASCII)
        }

        @Test func `Code collection uppercased converts letters only`() {
            let codes = [ASCII::ASCII.Code](ascii: "hello 123!")!
            let expected = [ASCII::ASCII.Code](ascii: "HELLO 123!")!
            #expect(codes.ascii.uppercased() == expected)
        }

        @Test func `Code collection lowercased converts letters only`() {
            let codes = [ASCII::ASCII.Code](ascii: "HELLO 123!")!
            let expected = [ASCII::ASCII.Code](ascii: "hello 123!")!
            #expect(codes.ascii.lowercased() == expected)
        }

        @Test func `Trimming removes matching codes from both ends`() {
            let codes = [ASCII::ASCII.Code](ascii: "  Hi  ")!
            let trimmed = codes.ascii.trimming([.sp])
            #expect(Array(trimmed) == [ASCII::ASCII.Code](ascii: "Hi")!)
        }

        @Test func `ElementsEqualCaseInsensitive matches differing case`() {
            let header = [ASCII::ASCII.Code](ascii: "Content-Type")!
            let lower = [ASCII::ASCII.Code](ascii: "content-type")!
            #expect(header.ascii.elementsEqualCaseInsensitive(lower))
        }

        @Test func `ElementsEqualCaseInsensitive rejects differing length`() {
            let header = [ASCII::ASCII.Code](ascii: "Content-Type")!
            let other = [ASCII::ASCII.Code](ascii: "Content")!
            #expect(!header.ascii.elementsEqualCaseInsensitive(other))
        }

        @Test func `ElementsEqualCaseInsensitive rejects differing content`() {
            let header = [ASCII::ASCII.Code](ascii: "Content-Type")!
            let other = [ASCII::ASCII.Code](ascii: "content-length")!
            #expect(!header.ascii.elementsEqualCaseInsensitive(other))
        }

        @Test func `HasPrefix caseInsensitive matches differing case prefix`() {
            let header = [ASCII::ASCII.Code](ascii: "Content-Type: text/plain")!
            let prefix = [ASCII::ASCII.Code](ascii: "content-type")!
            #expect(header.ascii.hasPrefix(caseInsensitive: prefix))
        }

        @Test func `HasPrefix caseInsensitive rejects a prefix longer than the source`() {
            let header = [ASCII::ASCII.Code](ascii: "Content")!
            let prefix = [ASCII::ASCII.Code](ascii: "Content-Type")!
            #expect(!header.ascii.hasPrefix(caseInsensitive: prefix))
        }

        @Test func `LineRanges splits on LF CR and CRLF`() {
            let codes = [ASCII::ASCII.Code](ascii: "a\r\nb\nc\rd")!
            let ranges = codes.ascii.lineRanges()
            let lines = ranges.map { String(decoding: codes[$0].map(\.underlying), as: UTF8.self) }
            #expect(lines == ["a", "b", "c", "d"])
        }

        @Test func `Lines returns copied code arrays per line`() {
            let codes = [ASCII::ASCII.Code](ascii: "Hello\r\nWorld")!
            let lines = codes.ascii.lines()
            #expect(lines.count == 2)
            #expect(lines[0] == [ASCII::ASCII.Code](ascii: "Hello")!)
            #expect(lines[1] == [ASCII::ASCII.Code](ascii: "World")!)
        }

        @Test func `Predicate accessors classify a homogeneous code collection`() {
            let digits = [ASCII::ASCII.Code](ascii: "12345")!
            #expect(digits.ascii.isAllDigits)
            #expect(!digits.ascii.isAllLetters)

            let letters = [ASCII::ASCII.Code](ascii: "hello")!
            #expect(letters.ascii.isAllLetters)
            #expect(letters.ascii.isAllLowercase)
            #expect(!letters.ascii.isAllUppercase)
        }

        @Test func `String isAllASCII reports non-ASCII content`() {
            #expect(INCITS_4_1986.ASCII("hello").isAllASCII)
            #expect(!INCITS_4_1986.ASCII("hello🌍").isAllASCII)
        }

        @Test func `String callAsFunction returns nil for non-ASCII input`() {
            #expect(INCITS_4_1986.ASCII("Hello")() == "Hello")
            #expect(INCITS_4_1986.ASCII("Hello🌍")() == nil)
        }

        @Test func `String uppercased and lowercased are Unicode-safe`() {
            #expect(INCITS_4_1986.ASCII("hello🌍").uppercased() == "HELLO🌍")
            #expect(INCITS_4_1986.ASCII("HELLO🌍").lowercased() == "hello🌍")
        }

        @Test func `String detectedLineEnding finds the first line ending style`() {
            #expect(INCITS_4_1986.ASCII("a\nb").detectedLineEnding() == .lf)
            #expect(INCITS_4_1986.ASCII("a\r\nb").detectedLineEnding() == .crlf)
            #expect(INCITS_4_1986.ASCII("a\rb").detectedLineEnding() == .cr)
            #expect(INCITS_4_1986.ASCII("ab").detectedLineEnding() == nil)
        }

        @Test func `String containsMixedLineEndings detects more than one style`() {
            #expect(INCITS_4_1986.ASCII("a\nb\r\nc").containsMixedLineEndings)
            #expect(!INCITS_4_1986.ASCII("a\nb\nc").containsMixedLineEndings)
        }

        @Test func `Static line ending constants decode to the expected strings`() {
            #expect(INCITS_4_1986.ASCII<String>.lf == "\n")
            #expect(INCITS_4_1986.ASCII<String>.cr == "\r")
            #expect(INCITS_4_1986.ASCII<String>.crlf == "\r\n")
        }

        @Test func `Unchecked decodes bytes without validation`() {
            let bytes: [UInt8] = [104, 101, 108, 108, 111]
            #expect(INCITS_4_1986.ASCII<String>.unchecked(bytes) == "hello")
        }
    }

    @Suite struct `INCITS views handles empty inputs and boundary values` {
        @Test func `Code collection containsNonASCII is always false`() {
            let codes = [ASCII::ASCII.Code](ascii: "hello")!
            #expect(!codes.ascii.containsNonASCII)
        }

        @Test func `Trimming an all-matching collection returns an empty subsequence`() {
            let codes = [ASCII::ASCII.Code](ascii: "   ")!
            let trimmed = codes.ascii.trimming([.sp])
            #expect(trimmed.isEmpty)
        }

        @Test func `LineRanges on an empty collection returns no ranges`() {
            let codes = [ASCII::ASCII.Code]()
            #expect(codes.ascii.lineRanges().isEmpty)
        }

        @Test func `LineRanges on text without a trailing line ending includes the final line`() {
            let codes = [ASCII::ASCII.Code](ascii: "onlyline")!
            let ranges = codes.ascii.lineRanges()
            #expect(ranges.count == 1)
            #expect(Array(codes[ranges[0]]) == codes)
        }

        @Test func `LineRanges on a trailing line ending does not emit an empty final line`() {
            let codes = [ASCII::ASCII.Code](ascii: "a\n")!
            let ranges = codes.ascii.lineRanges()
            #expect(ranges.count == 1)
        }

        @Test func `ElementsEqualCaseInsensitive on empty collections is true`() {
            let empty = [ASCII::ASCII.Code]()
            #expect(empty.ascii.elementsEqualCaseInsensitive(empty))
        }

        @Test func `String isAllWhitespace is vacuously true for an empty string`() {
            #expect(INCITS_4_1986.ASCII("").isAllWhitespace)
        }

        @Test func `String detectedLineEnding prioritizes CRLF over standalone CR or LF`() {
            #expect(INCITS_4_1986.ASCII("a\r\nb").detectedLineEnding() == .crlf)
        }
    }

    @Suite struct `INCITS views integrates with its consumers` {}
}
