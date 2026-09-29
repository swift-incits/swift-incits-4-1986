import Testing

import ASCII
import Byte
import Standard_Library_Extensions
@testable import INCITS_4_1986

@Suite
struct `Strings expose the INCITS ASCII view` {
    @Suite
    struct `Strings provide ASCII conversion trimming and normalization` {
        @Test
        func `String has ascii conversion method`() {
            let codes: [ASCII.Code] = [.H, .e, .l, .l, .o]
            let string = String(ascii: codes)
            #expect(string == "Hello")
        }

        @Test
        func `String has case conversion method`() {
            let str = "Hello"
            #expect(str.ascii(case: .upper) == "HELLO")
            #expect(str.ascii(case: .lower) == "hello")
        }

        @Test
        func `String has trimming method`() {
            let str = "  hello  "
            #expect(str.trimming(Set<Character>.ascii.whitespaces) == "hello")
        }

        @Test
        func `String has normalization method`() {
            let str = "hello\r\nworld"
            #expect(str.normalized(to: .lf) == "hello\nworld")
        }
    }

    @Suite
    struct `String views recognize text containing only ASCII` {
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
        func `Valid ASCII strings satisfy ASCII validation`(str: String) {
            #expect(str.ascii.isAllASCII, "String '\(str)' should be all ASCII")
        }

        @Test(arguments: [
            "Hello🌍",
            "café",
            "日本語",
            "Ñoño",
            "test\u{80}",
            "test\u{FF}",
        ])
        func `Strings with nonASCII characters fail ASCII validation`(str: String) {
            #expect(!str.ascii.isAllASCII, "String '\(str)' should contain non-ASCII")
        }
    }

    @Suite
    struct `String views recognize text containing only ASCII whitespace` {
        @Test(arguments: [
            " ",
            "  ",
            "\t",
            "\n",
            "\r",
            " \t\n\r",
            "    \t\t\n\n",
        ])
        func `Strings containing only whitespace satisfy the predicate`(str: String) {
            #expect(str.ascii.isAllWhitespace, "String '\(str)' should be all whitespace")
        }

        @Test(arguments: [
            "a",
            " a ",
            "  test  ",
            "\thello\t",
        ])
        func `Strings containing nonwhitespace characters fail the predicate`(str: String) {
            #expect(!str.ascii.isAllWhitespace, "String '\(str)' should not be all whitespace")
        }
    }

    @Suite
    struct `String views recognize text containing only digits` {
        @Test(arguments: [
            "0",
            "123",
            "0123456789",
            "999",
        ])
        func `Strings containing only digits satisfy the predicate`(str: String) {
            #expect(str.ascii.isAllDigits, "String '\(str)' should be all digits")
        }

        @Test(arguments: [
            "12a34",
            "test",
            "123 456",
            "1.23",
        ])
        func `Strings containing nondigits characters fail the predicate`(str: String) {
            #expect(!str.ascii.isAllDigits, "String '\(str)' should not be all digits")
        }
    }

    @Suite
    struct `String views recognize text containing only letters` {
        @Test(arguments: [
            "a",
            "ABC",
            "hello",
            "WORLD",
            "AbCdEfG",
        ])
        func `Strings containing only letters satisfy the predicate`(str: String) {
            #expect(str.ascii.isAllLetters, "String '\(str)' should be all letters")
        }

        @Test(arguments: [
            "hello123",
            "test ",
            "A-B",
            "hello_world",
        ])
        func `Strings containing nonletters characters fail the predicate`(str: String) {
            #expect(!str.ascii.isAllLetters, "String '\(str)' should not be all letters")
        }
    }

    @Suite
    struct `String views recognize text containing only letters and digits` {
        @Test(arguments: [
            "abc123",
            "ABC",
            "123",
            "Test123",
            "a1b2c3",
        ])
        func `Strings containing only letters and digits satisfy the predicate`(str: String) {
            #expect(str.ascii.isAllAlphanumeric, "String '\(str)' should be all alphanumeric")
        }

        @Test(arguments: [
            "hello world",
            "test-123",
            "A_B",
            "test!",
        ])
        func `Strings containing nonalphanumeric characters fail the predicate`(str: String) {
            #expect(!str.ascii.isAllAlphanumeric, "String '\(str)' should not be all alphanumeric")
        }
    }

    @Suite
    struct `String views recognize text containing only control characters` {
        @Test(arguments: [
            "\0",
            "\0\0",
            "\t",
            "\n",
            "\r",
            "\t\n\r",
            "\u{7F}",
        ])
        func `Strings containing only control characters satisfy the predicate`(str: String) {
            #expect(str.ascii.isAllControl, "String should be all control characters")
        }

        @Test(arguments: [
            "a",
            " ",
            "\ta\n",
            "hello",
        ])
        func `Strings containing noncontrol characters fail the predicate`(str: String) {
            #expect(!str.ascii.isAllControl, "String should not be all control characters")
        }
    }

    @Suite
    struct `String views recognize text containing only graphic characters` {
        @Test(arguments: [
            "!",
            "~",
            "ABC",
            "abc123!@#",
        ])
        func `Strings containing only graphic characters satisfy the predicate`(str: String) {
            #expect(str.ascii.isAllVisible, "String '\(str)' should be all visible")
        }

        @Test(arguments: [
            " ",
            "hello world",
            "\t",
            "test ",
        ])
        func `Strings containing nonvisible characters fail the predicate`(str: String) {
            #expect(!str.ascii.isAllVisible, "String '\(str)' should not be all visible")
        }
    }

    @Suite
    struct `String views recognize text containing only printable characters` {
        @Test(arguments: [
            " ",
            "hello world",
            "!@#$%",
            "ABC 123",
        ])
        func `Strings containing only printable characters satisfy the predicate`(str: String) {
            #expect(str.ascii.isAllPrintable, "String '\(str)' should be all printable")
        }

        @Test(arguments: [
            "\t",
            "\n",
            "hello\nworld",
            "\0",
        ])
        func `Strings containing nonprintable characters fail the predicate`(str: String) {
            #expect(!str.ascii.isAllPrintable, "String '\(str)' should not be all printable")
        }
    }

    @Suite
    struct `String views detect characters outside ASCII` {
        @Test(arguments: [
            "Hello🌍",
            "café",
            "日本語",
            "test\u{80}",
        ])
        func `Strings containing nonASCII characters are detected`(str: String) {
            #expect(str.ascii.containsNonASCII, "String '\(str)' should contain non-ASCII")
        }

        @Test(arguments: [
            "",
            "Hello",
            "test123",
            "!@#$%",
        ])
        func `Pure ASCII strings contain no nonASCII characters`(str: String) {
            #expect(!str.ascii.containsNonASCII, "String '\(str)' should not contain non-ASCII")
        }
    }

    @Suite
    struct `String views detect hexadecimal digits` {
        @Test(arguments: [
            "0",
            "9",
            "A",
            "F",
            "a",
            "f",
            "hello",
            "FACE",
            "test0",
        ])
        func `Strings containing hexadecimal digits are detected`(str: String) {
            #expect(str.ascii.containsHexDigit, "String '\(str)' should contain hex digit")
        }

        @Test(arguments: [
            "",
            "xyz",
            "!!!",
            "   ",
        ])
        func `Strings without hexadecimal digits fail the predicate`(str: String) {
            #expect(!str.ascii.containsHexDigit, "String '\(str)' should not contain hex digit")
        }
    }

    @Suite
    struct `String views recognize text without uppercase letters` {
        @Test(arguments: [
            "abc",
            "hello",
            "test123",
            "hello world",
            "a-b-c",
        ])
        func `Strings containing only lowercase letters satisfy the predicate`(str: String) {
            #expect(str.ascii.isAllLowercase, "String '\(str)' should be all lowercase")
        }

        @Test(arguments: [
            "ABC",
            "Hello",
            "tEst",
            "WORLD",
        ])
        func `Strings with uppercase letters fail lowercase classification`(str: String) {
            #expect(!str.ascii.isAllLowercase, "String '\(str)' should not be all lowercase")
        }

        @Test
        func `Empty string is all lowercase`() {
            #expect("".ascii.isAllLowercase)
        }

        @Test
        func `Non-letter string is all lowercase`() {
            #expect("123!@#".ascii.isAllLowercase)
        }
    }

    @Suite
    struct `String views recognize text without lowercase letters` {
        @Test(arguments: [
            "ABC",
            "HELLO",
            "TEST123",
            "HELLO WORLD",
            "A-B-C",
        ])
        func `Strings containing only uppercase letters satisfy the predicate`(str: String) {
            #expect(str.ascii.isAllUppercase, "String '\(str)' should be all uppercase")
        }

        @Test(arguments: [
            "abc",
            "Hello",
            "TeSt",
            "world",
        ])
        func `Strings with lowercase letters fail uppercase classification`(str: String) {
            #expect(!str.ascii.isAllUppercase, "String '\(str)' should not be all uppercase")
        }

        @Test
        func `Empty string is all uppercase`() {
            #expect("".ascii.isAllUppercase)
        }

        @Test
        func `Non-letter string is all uppercase`() {
            #expect("123!@#".ascii.isAllUppercase)
        }
    }

    @Suite
    struct `String views convert ASCII letter case` {
        @Test(arguments: [
            ("hello", "HELLO"),
            ("world", "WORLD"),
            ("TeSt", "TEST"),
            ("abc123", "ABC123"),
            ("", ""),
        ])
        func `Uppercased converts correctly`(input: String, expected: String) {
            #expect(input.ascii.uppercased() == expected)
        }

        @Test(arguments: [
            ("HELLO", "hello"),
            ("WORLD", "world"),
            ("TeSt", "test"),
            ("ABC123", "abc123"),
            ("", ""),
        ])
        func `Lowercased converts correctly`(input: String, expected: String) {
            #expect(input.ascii.lowercased() == expected)
        }

        @Test
        func `Convenience methods match ascii(case:)`() {
            let test = "Hello World"
            #expect(test.ascii.uppercased() == test.ascii(case: .upper))
            #expect(test.ascii.lowercased() == test.ascii(case: .lower))
        }

        @Test
        func `Case methods preserve nonASCII characters`() {
            let test = "Hello🌍"
            #expect(test.ascii.uppercased() == "HELLO🌍")
            #expect(test.ascii.lowercased() == "hello🌍")
        }
    }

    @Suite
    struct `String views expose line ending constants` {
        @Test
        func `Lf constant is correct`() {
            let lf: String = .ascii.lf
            #expect(lf == "\n")
            #expect(lf.count == 1)
        }

        @Test
        func `Cr constant is correct`() {
            let cr: String = .ascii.cr
            #expect(cr == "\r")
            #expect(cr.count == 1)
        }

        @Test
        func `Crlf constant is correct`() {
            let crlf: String = .ascii.crlf
            #expect(crlf == "\r\n")
            #expect(crlf.utf8.count == 2)
        }

        @Test
        func `Constants match byte values`() {
            #expect(.ascii.lf == String(decoding: [ASCII::ASCII.Code.lf.underlying], as: UTF8.self))
            #expect(.ascii.cr == String(decoding: [ASCII::ASCII.Code.cr.underlying], as: UTF8.self))
            #expect(
                .ascii.crlf == String(decoding: INCITS_4_1986.Character.Control.crlf, as: UTF8.self)
            )
        }
    }

    @Suite
    struct `String views detect mixed line ending styles` {
        @Test(arguments: [
            "line1\nline2\r\nline3",
            "line1\rline2\nline3",
            "line1\nline2\rline3\r\nline4",
        ])
        func `String views detect mixed line endings`(str: String) {
            #expect(str.ascii.containsMixedLineEndings, "String should have mixed line endings")
        }

        @Test(arguments: [
            "",
            "hello",
            "line1\nline2\nline3",
            "line1\rline2\rline3",
            "line1\r\nline2\r\nline3",
        ])
        func `String views reject consistent and absent line endings as mixed`(str: String) {
            #expect(
                !str.ascii.containsMixedLineEndings,
                "String should not have mixed line endings"
            )
        }
    }

    @Suite
    struct `String views identify the preferred line ending style` {
        @Test(arguments: [
            ("line1\nline2", INCITS_4_1986.FormatEffectors.Line.Ending.lf),
            ("line1\n", .lf),
            ("\n", .lf),
        ])
        func `Line ending detection detects LF`(str: String, expected: INCITS_4_1986.FormatEffectors.Line.Ending) {
            #expect(str.ascii.detectedLineEnding() == expected)
        }

        @Test(arguments: [
            ("line1\rline2", INCITS_4_1986.FormatEffectors.Line.Ending.cr),
            ("line1\r", .cr),
            ("\r", .cr),
        ])
        func `Line ending detection detects CR`(str: String, expected: INCITS_4_1986.FormatEffectors.Line.Ending) {
            #expect(str.ascii.detectedLineEnding() == expected)
        }

        @Test(arguments: [
            ("line1\r\nline2", INCITS_4_1986.FormatEffectors.Line.Ending.crlf),
            ("line1\r\n", .crlf),
            ("\r\n", .crlf),
        ])
        func `Line ending detection detects CRLF`(str: String, expected: INCITS_4_1986.FormatEffectors.Line.Ending) {
            #expect(str.ascii.detectedLineEnding() == expected)
        }

        @Test
        func `Line ending detection returns nil when no line endings`() {
            #expect("hello world".ascii.detectedLineEnding() == nil)
            #expect("".ascii.detectedLineEnding() == nil)
        }

        @Test
        func `Line ending detection prioritizes CRLF over individual CR or LF`() {

            let str = "line1\r\nline2\nline3"
            #expect(str.ascii.detectedLineEnding() == .crlf)
        }
    }
}
