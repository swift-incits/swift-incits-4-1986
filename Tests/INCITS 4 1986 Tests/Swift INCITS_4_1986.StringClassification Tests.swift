import ASCII
import Byte
import Standard_Library_Extensions
import Testing

@testable import INCITS_4_1986

@Suite
struct `INCITS classifies ASCII text` {

    @Suite
    struct `Text predicates recognize text containing only ASCII` {
        @Test(arguments: [
            "Hello",
            "test123",
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
            "abcdefghijklmnopqrstuvwxyz",
            "0123456789",
            "!@#$%^&*()",
            "",
            " \t\n\r",
        ])
        func `The predicate returns true for ASCII-only strings`(str: String) {
            #expect(INCITS_4_1986.Text.Classification.isAllASCII(str))
        }

        @Test(arguments: [
            "Hello🌍",
            "café",
            "日本語",
            "Ñoño",
            "test\u{80}",
            "test\u{FF}",
        ])
        func `The predicate returns false for strings with non-ASCII`(str: String) {
            #expect(!INCITS_4_1986.Text.Classification.isAllASCII(str))
        }
    }

    @Suite
    struct `Text predicates detect characters outside ASCII` {
        @Test(arguments: [
            "Hello🌍",
            "café",
            "日本語",
            "Ñoño",
            "test\u{80}",
            "test\u{FF}",
        ])
        func `The predicate returns true for strings with non-ASCII`(str: String) {
            #expect(INCITS_4_1986.Text.Classification.containsNonASCII(str))
        }

        @Test(arguments: [
            "Hello",
            "test123",
            "!@#$%^&*()",
            "",
            " \t\n\r",
        ])
        func `The predicate returns false for ASCII-only strings`(str: String) {
            #expect(!INCITS_4_1986.Text.Classification.containsNonASCII(str))
        }
    }

    @Suite
    struct `Text predicates recognize text containing only ASCII whitespace` {
        @Test(arguments: [
            " ",
            "  ",
            "\t",
            "\n",
            "\r",
            " \t\n\r",
            "    \t\t\n\n",
        ])
        func `The predicate returns true for all-whitespace strings`(str: String) {
            #expect(INCITS_4_1986.Text.Classification.isAllWhitespace(str))
        }

        @Test(arguments: [
            "a",
            " a ",
            "  test  ",
            "\thello\t",
        ])
        func `The predicate returns false for non-whitespace strings`(str: String) {
            #expect(!INCITS_4_1986.Text.Classification.isAllWhitespace(str))
        }
    }

    @Suite
    struct `Text predicates recognize text containing only digits` {
        @Test(arguments: [
            "0",
            "123",
            "0123456789",
            "999",
        ])
        func `The predicate returns true for all-digit strings`(str: String) {
            #expect(INCITS_4_1986.Text.Classification.isAllDigits(str))
        }

        @Test(arguments: [
            "12a34",
            "test",
            "123 456",
            "1.23",
        ])
        func `The predicate returns false for non-digit strings`(str: String) {
            #expect(!INCITS_4_1986.Text.Classification.isAllDigits(str))
        }
    }

    @Suite
    struct `Text predicates recognize text containing only letters` {
        @Test(arguments: [
            "a",
            "ABC",
            "hello",
            "WORLD",
            "AbCdEfG",
        ])
        func `The predicate returns true for all-letter strings`(str: String) {
            #expect(INCITS_4_1986.Text.Classification.isAllLetters(str))
        }

        @Test(arguments: [
            "hello123",
            "test ",
            "Hello-World",
            "café",
        ])
        func `The predicate returns false for non-letter strings`(str: String) {
            #expect(!INCITS_4_1986.Text.Classification.isAllLetters(str))
        }
    }

    @Suite
    struct `Text predicates recognize text containing only letters and digits` {
        @Test(arguments: [
            "abc123",
            "TEST123",
            "0123456789",
            "abcdefghijklmnopqrstuvwxyz",
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        ])
        func `The predicate returns true for all-alphanumeric strings`(str: String) {
            #expect(INCITS_4_1986.Text.Classification.isAllAlphanumeric(str))
        }

        @Test(arguments: [
            "test-123",
            "hello world",
            "test!",
            "123.456",
        ])
        func `The predicate returns false for non-alphanumeric strings`(str: String) {
            #expect(!INCITS_4_1986.Text.Classification.isAllAlphanumeric(str))
        }
    }

    @Suite
    struct `Text predicates recognize text containing only control characters` {
        @Test(arguments: [
            "\t",
            "\n",
            "\r",
            "\u{00}",
            "\u{1F}",
            "\u{7F}",
            "\t\n\r",
        ])
        func `The predicate returns true for all-control strings`(str: String) {
            #expect(INCITS_4_1986.Text.Classification.isAllControl(str))
        }

        @Test(arguments: [
            "a",
            " ",
            "\tA",
            "test\n",
        ])
        func `The predicate returns false for non-control strings`(str: String) {
            #expect(!INCITS_4_1986.Text.Classification.isAllControl(str))
        }
    }

    @Suite
    struct `Text predicates recognize text containing only graphic characters` {
        @Test(arguments: [
            "!",
            "abc",
            "ABC123",
            "!@#$%^&*()",
            "~",
        ])
        func `The predicate returns true for all-visible strings`(str: String) {
            #expect(INCITS_4_1986.Text.Classification.isAllVisible(str))
        }

        @Test(arguments: [
            " ",
            "hello ",
            " world",
            "test\n",
        ])
        func `The predicate returns false for non-visible strings`(str: String) {
            #expect(!INCITS_4_1986.Text.Classification.isAllVisible(str))
        }
    }

    @Suite
    struct `Text predicates recognize text containing only printable characters` {
        @Test(arguments: [
            " ",
            "Hello World",
            "ABC 123",
            "!@#$%^&*()",
            "test test",
        ])
        func `The predicate returns true for all-printable strings`(str: String) {
            #expect(INCITS_4_1986.Text.Classification.isAllPrintable(str))
        }

        @Test(arguments: [
            "Hello\n",
            "\t",
            "test\r\n",
            "\u{00}",
        ])
        func `The predicate returns false for non-printable strings`(str: String) {
            #expect(!INCITS_4_1986.Text.Classification.isAllPrintable(str))
        }
    }

    @Suite
    struct `Text predicates detect hexadecimal digits` {
        @Test(arguments: [
            "0x1A",
            "ABC",
            "123",
            "0123456789",
            "ABCDEF",
            "abcdef",
        ])
        func `The predicate returns true for strings with hex digits`(str: String) {
            #expect(INCITS_4_1986.Text.Classification.containsHexDigit(str))
        }

        @Test(arguments: [
            "",
            "GHIJKL",
            "xyz",
            "pqrs",
            "mnopqr",
        ])
        func `The predicate returns false for strings without hex digits`(str: String) {
            #expect(!INCITS_4_1986.Text.Classification.containsHexDigit(str))
        }
    }

    @Suite
    struct `Text predicates recognize text without uppercase letters` {
        @Test(arguments: [
            "hello",
            "world",
            "abcdefghijklmnopqrstuvwxyz",
            "hello123",
            "test-case",
            "123",
        ])
        func `The predicate returns true when all letters are lowercase`(str: String) {
            #expect(INCITS_4_1986.Text.Classification.isAllLowercase(str))
        }

        @Test(arguments: [
            "Hello",
            "WORLD",
            "Test",
            "helloWORLD",
        ])
        func `The predicate returns false when any letter is uppercase`(str: String) {
            #expect(!INCITS_4_1986.Text.Classification.isAllLowercase(str))
        }
    }

    @Suite
    struct `Text predicates recognize text without lowercase letters` {
        @Test(arguments: [
            "HELLO",
            "WORLD",
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
            "HELLO123",
            "TEST-CASE",
            "123",
        ])
        func `The predicate returns true when all letters are uppercase`(str: String) {
            #expect(INCITS_4_1986.Text.Classification.isAllUppercase(str))
        }

        @Test(arguments: [
            "Hello",
            "world",
            "Test",
            "HELLOworld",
        ])
        func `The predicate returns false when any letter is lowercase`(str: String) {
            #expect(!INCITS_4_1986.Text.Classification.isAllUppercase(str))
        }
    }

    @Suite
    struct `Empty text satisfies universal character predicates` {
        @Test
        func `Empty string is all ASCII`() {
            #expect(INCITS_4_1986.Text.Classification.isAllASCII(""))
        }

        @Test
        func `Empty string is all whitespace`() {

            #expect(INCITS_4_1986.Text.Classification.isAllWhitespace(""))
        }

        @Test
        func `Empty string is all digits`() {

            #expect(INCITS_4_1986.Text.Classification.isAllDigits(""))
        }

        @Test
        func `Empty string is all letters`() {

            #expect(INCITS_4_1986.Text.Classification.isAllLetters(""))
        }

        @Test
        func `Empty string is all alphanumeric`() {

            #expect(INCITS_4_1986.Text.Classification.isAllAlphanumeric(""))
        }

        @Test
        func `Empty string is all control`() {

            #expect(INCITS_4_1986.Text.Classification.isAllControl(""))
        }

        @Test
        func `Empty string is all visible`() {

            #expect(INCITS_4_1986.Text.Classification.isAllVisible(""))
        }

        @Test
        func `Empty string is all printable`() {

            #expect(INCITS_4_1986.Text.Classification.isAllPrintable(""))
        }

        @Test
        func `Empty string contains no hex digits`() {
            #expect(!INCITS_4_1986.Text.Classification.containsHexDigit(""))
        }

        @Test
        func `Empty string is all lowercase`() {

            #expect(INCITS_4_1986.Text.Classification.isAllLowercase(""))
        }

        @Test
        func `Empty string is all uppercase`() {

            #expect(INCITS_4_1986.Text.Classification.isAllUppercase(""))
        }
    }

    @Suite
    struct `NonASCII characters fail ASCII classification predicates` {
        @Test
        func `Non-ASCII characters fail letter test`() {
            #expect(!INCITS_4_1986.Text.Classification.isAllLetters("café"))
        }

        @Test
        func `Non-ASCII characters fail alphanumeric test`() {
            #expect(!INCITS_4_1986.Text.Classification.isAllAlphanumeric("test123🌍"))
        }

        @Test
        func `Non-ASCII characters fail whitespace test`() {

            #expect(!INCITS_4_1986.Text.Classification.isAllWhitespace("\u{00A0}"))
        }
    }
}
