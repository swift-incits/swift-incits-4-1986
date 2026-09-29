import Testing

@testable import INCITS_4_1986

extension INCITS_4_1986.Text.Classification {
    @Suite struct `INCITS text predicates classify ASCII characters` {
        @Suite struct `INCITS text classification provides its declared operations` {
            @Test func `IsAllASCII rejects a string containing a multi-byte character`() {
                #expect(INCITS_4_1986.Text.Classification.isAllASCII("Hello"))
                #expect(!INCITS_4_1986.Text.Classification.isAllASCII("café"))
                #expect(!INCITS_4_1986.Text.Classification.isAllASCII("Hello🌍"))
            }

            @Test func `ContainsNonASCII is the complement of isAllASCII`() {
                #expect(!INCITS_4_1986.Text.Classification.containsNonASCII("Hello"))
                #expect(INCITS_4_1986.Text.Classification.containsNonASCII("café"))
            }

            @Test func `IsAllWhitespace recognizes SPACE TAB LF and CR`() {
                #expect(INCITS_4_1986.Text.Classification.isAllWhitespace("   "))
                #expect(INCITS_4_1986.Text.Classification.isAllWhitespace("\t\n\r"))
                #expect(!INCITS_4_1986.Text.Classification.isAllWhitespace(" a "))
            }

            @Test func `IsAllDigits accepts only 0 through 9`() {
                #expect(INCITS_4_1986.Text.Classification.isAllDigits("12345"))
                #expect(!INCITS_4_1986.Text.Classification.isAllDigits("123a45"))
            }

            @Test func `IsAllLetters accepts only A-Z and a-z`() {
                #expect(INCITS_4_1986.Text.Classification.isAllLetters("Hello"))
                #expect(!INCITS_4_1986.Text.Classification.isAllLetters("Hello123"))
            }

            @Test func `IsAllAlphanumeric accepts digits and letters`() {
                #expect(INCITS_4_1986.Text.Classification.isAllAlphanumeric("Hello123"))
                #expect(!INCITS_4_1986.Text.Classification.isAllAlphanumeric("Hello-123"))
            }

            @Test func `IsAllControl accepts only control bytes`() {
                #expect(INCITS_4_1986.Text.Classification.isAllControl("\t\n"))
                #expect(!INCITS_4_1986.Text.Classification.isAllControl("\tA"))
            }

            @Test func `IsAllVisible excludes SPACE`() {
                #expect(INCITS_4_1986.Text.Classification.isAllVisible("Hello!"))
                #expect(!INCITS_4_1986.Text.Classification.isAllVisible("Hello "))
            }

            @Test func `IsAllPrintable includes SPACE but excludes control characters`() {
                #expect(INCITS_4_1986.Text.Classification.isAllPrintable("Hello World"))
                #expect(!INCITS_4_1986.Text.Classification.isAllPrintable("Hello\n"))
            }

            @Test func `ContainsHexDigit finds any of 0-9 A-F a-f`() {
                #expect(INCITS_4_1986.Text.Classification.containsHexDigit("0x1A"))
                #expect(!INCITS_4_1986.Text.Classification.containsHexDigit("story"))
            }

            @Test func `IsAllLowercase ignores digits and non-letters`() {
                #expect(INCITS_4_1986.Text.Classification.isAllLowercase("hello"))
                #expect(INCITS_4_1986.Text.Classification.isAllLowercase("hello123"))
                #expect(!INCITS_4_1986.Text.Classification.isAllLowercase("Hello"))
            }

            @Test func `IsAllUppercase ignores digits and non-letters`() {
                #expect(INCITS_4_1986.Text.Classification.isAllUppercase("HELLO"))
                #expect(INCITS_4_1986.Text.Classification.isAllUppercase("HELLO123"))
                #expect(!INCITS_4_1986.Text.Classification.isAllUppercase("Hello"))
            }
        }

        @Suite struct `INCITS text classification handles empty inputs and boundary values` {
            @Test func `Every predicate is vacuously true for an empty string`() {
                #expect(INCITS_4_1986.Text.Classification.isAllWhitespace(""))
                #expect(INCITS_4_1986.Text.Classification.isAllDigits(""))
                #expect(INCITS_4_1986.Text.Classification.isAllLetters(""))
                #expect(INCITS_4_1986.Text.Classification.isAllAlphanumeric(""))
                #expect(INCITS_4_1986.Text.Classification.isAllControl(""))
                #expect(INCITS_4_1986.Text.Classification.isAllVisible(""))
                #expect(INCITS_4_1986.Text.Classification.isAllPrintable(""))
                #expect(INCITS_4_1986.Text.Classification.isAllLowercase(""))
                #expect(INCITS_4_1986.Text.Classification.isAllUppercase(""))
            }

            @Test func `ContainsHexDigit is false for an empty string`() {
                #expect(!INCITS_4_1986.Text.Classification.containsHexDigit(""))
            }

            @Test func `IsAllLowercase and isAllUppercase are both true with no letters present`() {
                #expect(INCITS_4_1986.Text.Classification.isAllLowercase("123"))
                #expect(INCITS_4_1986.Text.Classification.isAllUppercase("123"))
            }

            @Test func `Boundary bytes 0x7F control and 0x7E visible classify correctly`() {
                #expect(INCITS_4_1986.Text.Classification.isAllControl("\u{7F}"))
                #expect(INCITS_4_1986.Text.Classification.isAllVisible("\u{7E}"))
                #expect(!INCITS_4_1986.Text.Classification.isAllVisible("\u{7F}"))
            }

            @Test func `Boundary byte 0x20 SPACE is printable but not visible`() {
                #expect(INCITS_4_1986.Text.Classification.isAllPrintable(" "))
                #expect(!INCITS_4_1986.Text.Classification.isAllVisible(" "))
            }

            @Test func `IsAllLowercase and isAllUppercase ignore non-ASCII code points`() {
                #expect(INCITS_4_1986.Text.Classification.isAllLowercase("café"))
                #expect(INCITS_4_1986.Text.Classification.isAllUppercase("CAF🌍"))
            }
        }

        @Suite struct `INCITS text classification integrates with its consumers` {}
    }
}
