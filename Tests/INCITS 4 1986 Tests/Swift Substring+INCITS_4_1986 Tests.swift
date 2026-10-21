import ASCII
import Byte
import Standard_Library_Extensions
import Testing

@testable import INCITS_4_1986

@Suite
struct `Substrings expose the INCITS ASCII view` {
    @Suite
    struct `Substrings provide ASCII conversion and trimming` {
        @Test
        func `Substring has trimming method`() {
            let str = "  hello  "
            let sub = str[...]
            #expect(sub.trimming(.ascii.whitespaces) == "hello")
        }

        @Test
        func `Substring trimming preserves content`() {
            let str = "  test content  "
            let sub = str[...]
            let trimmed = sub.trimming(.ascii.whitespaces)
            #expect(trimmed == "test content")
        }

        @Test
        func `Substring trimming removes the requested custom characters`() {
            let str = "***hello***"
            let sub = str[...]
            let trimmed = sub.trimming(Set<Character>(["*"]))
            #expect(trimmed == "hello")
        }

        @Test
        func `Substring trimming preserves an empty string`() {
            let str = ""
            let sub = str[...]
            #expect(sub.trimming(.ascii.whitespaces).isEmpty)
        }

        @Test
        func `Substring has case conversion method`() {
            let sub = "Hello"[...]
            #expect(sub.ascii(case: .upper) == "HELLO")
            #expect(sub.ascii(case: .lower) == "hello")
        }
    }

    @Suite
    struct `Substring views recognize text containing only ASCII` {
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
        func `Valid ASCII substrings satisfy ASCII validation`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.isAllASCII, "Substring '\(sub)' should be all ASCII")
        }

        @Test(arguments: [
            "Hello🌍",
            "café",
            "日本語",
            "Ñoño",
            "test\u{80}",
            "test\u{FF}",
        ])
        func `Substrings with nonASCII characters fail ASCII validation`(str: String) {
            let sub = str[...]
            #expect(!sub.ascii.isAllASCII, "Substring '\(sub)' should contain non-ASCII")
        }
    }

    @Suite
    struct `Substring views recognize text containing only ASCII whitespace` {
        @Test(arguments: [
            " ",
            "  ",
            "\t",
            "\n",
            "\r",
            " \t\n\r",
            "    \t\t\n\n",
        ])
        func `Substrings containing only whitespace satisfy the predicate`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.isAllWhitespace, "Substring should be all whitespace")
        }

        @Test(arguments: [
            "a",
            " a ",
            "  test  ",
            "\thello\t",
        ])
        func `Substrings containing nonwhitespace characters fail the predicate`(str: String) {
            let sub = str[...]
            #expect(!sub.ascii.isAllWhitespace, "Substring should not be all whitespace")
        }
    }

    @Suite
    struct `Substring views recognize text containing only digits` {
        @Test(arguments: [
            "0",
            "123",
            "0123456789",
            "999",
        ])
        func `Substrings containing only digits satisfy the predicate`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.isAllDigits, "Substring '\(sub)' should be all digits")
        }

        @Test(arguments: [
            "12a34",
            "test",
            "123 456",
            "1.23",
        ])
        func `Substrings containing nondigits characters fail the predicate`(str: String) {
            let sub = str[...]
            #expect(!sub.ascii.isAllDigits, "Substring '\(sub)' should not be all digits")
        }
    }

    @Suite
    struct `Substring views recognize text containing only letters` {
        @Test(arguments: [
            "a",
            "ABC",
            "hello",
            "WORLD",
            "AbCdEfG",
        ])
        func `Substrings containing only letters satisfy the predicate`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.isAllLetters, "Substring '\(sub)' should be all letters")
        }

        @Test(arguments: [
            "hello123",
            "test ",
            "A-B",
            "hello_world",
        ])
        func `Substrings containing nonletters characters fail the predicate`(str: String) {
            let sub = str[...]
            #expect(!sub.ascii.isAllLetters, "Substring '\(sub)' should not be all letters")
        }
    }

    @Suite
    struct `Substring views recognize text containing only letters and digits` {
        @Test(arguments: [
            "abc123",
            "ABC",
            "123",
            "Test123",
            "a1b2c3",
        ])
        func `Substrings containing only letters and digits satisfy the predicate`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.isAllAlphanumeric, "Substring '\(sub)' should be all alphanumeric")
        }

        @Test(arguments: [
            "hello world",
            "test-123",
            "A_B",
            "test!",
        ])
        func `Substrings containing nonalphanumeric characters fail the predicate`(str: String) {
            let sub = str[...]
            #expect(
                !sub.ascii.isAllAlphanumeric,
                "Substring '\(sub)' should not be all alphanumeric"
            )
        }
    }

    @Suite
    struct `Substring views recognize text containing only control characters` {
        @Test(arguments: [
            "\0",
            "\0\0",
            "\t",
            "\n",
            "\r",
            "\t\n\r",
            "\u{7F}",
        ])
        func `Substrings containing only control characters satisfy the predicate`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.isAllControl, "Substring should be all control characters")
        }

        @Test(arguments: [
            "a",
            " ",
            "\ta\n",
            "hello",
        ])
        func `Substrings containing noncontrol characters fail the predicate`(str: String) {
            let sub = str[...]
            #expect(!sub.ascii.isAllControl, "Substring should not be all control characters")
        }
    }

    @Suite
    struct `Substring views recognize text containing only graphic characters` {
        @Test(arguments: [
            "!",
            "~",
            "ABC",
            "abc123!@#",
        ])
        func `Substrings containing only graphic characters satisfy the predicate`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.isAllVisible, "Substring '\(sub)' should be all visible")
        }

        @Test(arguments: [
            " ",
            "hello world",
            "\t",
            "test ",
        ])
        func `Substrings containing nonvisible characters fail the predicate`(str: String) {
            let sub = str[...]
            #expect(!sub.ascii.isAllVisible, "Substring '\(sub)' should not be all visible")
        }
    }

    @Suite
    struct `Substring views recognize text containing only printable characters` {
        @Test(arguments: [
            " ",
            "hello world",
            "!@#$%",
            "ABC 123",
        ])
        func `Substrings containing only printable characters satisfy the predicate`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.isAllPrintable, "Substring '\(sub)' should be all printable")
        }

        @Test(arguments: [
            "\t",
            "\n",
            "hello\nworld",
            "\0",
        ])
        func `Substrings containing nonprintable characters fail the predicate`(str: String) {
            let sub = str[...]
            #expect(!sub.ascii.isAllPrintable, "Substring '\(sub)' should not be all printable")
        }
    }

    @Suite
    struct `Substring views detect characters outside ASCII` {
        @Test(arguments: [
            "Hello🌍",
            "café",
            "日本語",
            "test\u{80}",
        ])
        func `Substrings containing nonASCII characters are detected`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.containsNonASCII, "Substring '\(sub)' should contain non-ASCII")
        }

        @Test(arguments: [
            "",
            "Hello",
            "test123",
            "!@#$%",
        ])
        func `Pure ASCII substrings contain no nonASCII characters`(str: String) {
            let sub = str[...]
            #expect(!sub.ascii.containsNonASCII, "Substring '\(sub)' should not contain non-ASCII")
        }
    }

    @Suite
    struct `Substring views detect hexadecimal digits` {
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
        func `Substrings containing hexadecimal digits are detected`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.containsHexDigit, "Substring '\(sub)' should contain hex digit")
        }

        @Test(arguments: [
            "",
            "xyz",
            "!!!",
            "   ",
        ])
        func `Substrings without hexadecimal digits fail the predicate`(str: String) {
            let sub = str[...]
            #expect(!sub.ascii.containsHexDigit, "Substring '\(sub)' should not contain hex digit")
        }
    }

    @Suite
    struct `Substring views recognize text without uppercase letters` {
        @Test(arguments: [
            "abc",
            "hello",
            "test123",
            "hello world",
            "a-b-c",
        ])
        func `Substrings containing only lowercase letters satisfy the predicate`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.isAllLowercase, "Substring '\(sub)' should be all lowercase")
        }

        @Test(arguments: [
            "ABC",
            "Hello",
            "tEst",
            "WORLD",
        ])
        func `Substrings with uppercase letters fail lowercase classification`(str: String) {
            let sub = str[...]
            #expect(!sub.ascii.isAllLowercase, "Substring '\(sub)' should not be all lowercase")
        }

        @Test
        func `Empty substring is all lowercase`() {
            #expect(""[...].ascii.isAllLowercase)
        }

        @Test
        func `Non-letter substring is all lowercase`() {
            #expect("123!@#"[...].ascii.isAllLowercase)
        }
    }

    @Suite
    struct `Substring views recognize text without lowercase letters` {
        @Test(arguments: [
            "ABC",
            "HELLO",
            "TEST123",
            "HELLO WORLD",
            "A-B-C",
        ])
        func `Substrings containing only uppercase letters satisfy the predicate`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.isAllUppercase, "Substring '\(sub)' should be all uppercase")
        }

        @Test(arguments: [
            "abc",
            "Hello",
            "TeSt",
            "world",
        ])
        func `Substrings with lowercase letters fail uppercase classification`(str: String) {
            let sub = str[...]
            #expect(!sub.ascii.isAllUppercase, "Substring '\(sub)' should not be all uppercase")
        }

        @Test
        func `Empty substring is all uppercase`() {
            #expect(""[...].ascii.isAllUppercase)
        }

        @Test
        func `Non-letter substring is all uppercase`() {
            #expect("123!@#"[...].ascii.isAllUppercase)
        }
    }

    @Suite
    struct `Substrings convert ASCII letter case` {
        @Test(arguments: [
            ("hello", "HELLO"),
            ("world", "WORLD"),
            ("TeSt", "TEST"),
            ("abc123", "ABC123"),
            ("", ""),
        ])
        func `Substring case conversion produces uppercase letters`(input: String, expected: String) {
            let sub = input[...]
            #expect(sub.ascii(case: .upper) == expected)
        }

        @Test(arguments: [
            ("HELLO", "hello"),
            ("WORLD", "world"),
            ("TeSt", "test"),
            ("ABC123", "abc123"),
            ("", ""),
        ])
        func `Substring case conversion produces lowercase letters`(input: String, expected: String) {
            let sub = input[...]
            #expect(sub.ascii(case: .lower) == expected)
        }

        @Test
        func `Substring case conversion preserves nonASCII characters`() {
            let sub = "Hello🌍"[...]
            #expect(sub.ascii(case: .upper) == "HELLO🌍")
            #expect(sub.ascii(case: .lower) == "hello🌍")
        }
    }

    @Suite
    struct `Substring views convert ASCII letter case` {
        @Test(arguments: [
            ("hello", "HELLO"),
            ("world", "WORLD"),
            ("TeSt", "TEST"),
            ("abc123", "ABC123"),
            ("", ""),
        ])
        func `Uppercased converts correctly`(input: String, expected: String) {
            let sub = input[...]
            #expect(sub.ascii.uppercased() == expected)
        }

        @Test(arguments: [
            ("HELLO", "hello"),
            ("WORLD", "world"),
            ("TeSt", "test"),
            ("ABC123", "abc123"),
            ("", ""),
        ])
        func `Lowercased converts correctly`(input: String, expected: String) {
            let sub = input[...]
            #expect(sub.ascii.lowercased() == expected)
        }

        @Test
        func `Convenience methods match ascii(case:)`() {
            let sub = "Hello World"[...]
            #expect(sub.ascii.uppercased() == sub.ascii(case: .upper))
            #expect(sub.ascii.lowercased() == sub.ascii(case: .lower))
        }

        @Test
        func `Case methods preserve nonASCII characters`() {
            let sub = "Hello🌍"[...]
            #expect(sub.ascii.uppercased() == "HELLO🌍")
            #expect(sub.ascii.lowercased() == "hello🌍")
        }
    }

    @Suite
    struct `Substring views expose line ending constants` {
        @Test
        func `Lf constant is correct`() {
            #expect(.ascii.lf == "\n")
            #expect(String.ascii.lf.count == 1)
        }

        @Test
        func `Cr constant is correct`() {
            #expect(.ascii.cr == "\r")
            #expect(String.ascii.cr.count == 1)
        }

        @Test
        func `Crlf constant is correct`() {
            #expect(.ascii.crlf == "\r\n")
            #expect(Substring.ascii.crlf.utf8.count == 2)
        }
    }

    @Suite
    struct `Substring views detect mixed line ending styles` {
        @Test(arguments: [
            "line1\nline2\r\nline3",
            "line1\rline2\nline3",
            "line1\nline2\rline3\r\nline4",
        ])
        func `Substring views detect mixed line endings`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.containsMixedLineEndings, "Substring should have mixed line endings")
        }

        @Test(arguments: [
            "",
            "hello",
            "line1\nline2\nline3",
            "line1\rline2\rline3",
            "line1\r\nline2\r\nline3",
        ])
        func `Substring views reject consistent and absent line endings as mixed`(str: String) {
            let sub = str[...]
            #expect(
                !sub.ascii.containsMixedLineEndings,
                "Substring should not have mixed line endings"
            )
        }
    }

    @Suite
    struct `Substring views identify the preferred line ending style` {
        @Test(arguments: [
            "line1\nline2",
            "line1\n",
            "\n",
        ])
        func `Line ending detection detects LF`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.detectedLineEnding() == .lf)
        }

        @Test(arguments: [
            "line1\rline2",
            "line1\r",
            "\r",
        ])
        func `Line ending detection detects CR`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.detectedLineEnding() == .cr)
        }

        @Test(arguments: [
            "line1\r\nline2",
            "line1\r\n",
            "\r\n",
        ])
        func `Line ending detection detects CRLF`(str: String) {
            let sub = str[...]
            #expect(sub.ascii.detectedLineEnding() == .crlf)
        }

        @Test
        func `Line ending detection returns nil when no line endings`() {
            #expect("hello world"[...].ascii.detectedLineEnding() == nil)
            #expect(""[...].ascii.detectedLineEnding() == nil)
        }

        @Test
        func `Line ending detection prioritizes CRLF over individual CR or LF`() {
            let sub = "line1\r\nline2\nline3"[...]
            #expect(sub.ascii.detectedLineEnding() == .crlf)
        }
    }
}
