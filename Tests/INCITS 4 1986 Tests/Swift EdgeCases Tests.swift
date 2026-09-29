import Testing

import ASCII
import Byte
import Standard_Library_Extensions
@testable import INCITS_4_1986

private func isAllASCII(_ bytes: [Byte]) -> Bool {
    bytes.allSatisfy { (try? ASCII.Code($0)) != nil }
}

@Suite
struct `ASCII operations respect character boundaries and empty inputs` {
    @Suite
    struct `Classification respects the exact ASCII boundaries` {
        @Test
        func `Boundary at 0x7F is valid ASCII`() {
            #expect(isAllASCII([ASCII::ASCII.Code.del.byte]))
        }

        @Test
        func `Boundary at 0x80 is invalid ASCII`() {
            #expect(!isAllASCII([Byte(0x80)]))
        }

        @Test
        func `The lower ASCII boundary is a valid control character`() {

            #expect(isAllASCII([ASCII::ASCII.Code.nul.byte]))
            #expect(ASCII::ASCII.Code.nul.isControl)
        }

        @Test
        func `The first byte above the ASCII range is rejected`() {

            let extendedASCII: UInt8 = 0x80
            #expect(!isAllASCII([Byte(bitPattern: extendedASCII)]))
            #expect(!extendedASCII.ascii.isControl)
            #expect(!extendedASCII.ascii.isPrintable)
        }

        @Test
        func `Letter boundaries are precise`() {

            #expect((ASCII::ASCII.Code.A.underlying - 1).ascii.isLetter == false)
            #expect(ASCII::ASCII.Code.A.isLetter == true)
            #expect(ASCII::ASCII.Code.Z.isLetter == true)
            #expect((ASCII::ASCII.Code.Z.underlying + 1).ascii.isLetter == false)

            #expect((ASCII::ASCII.Code.a.underlying - 1).ascii.isLetter == false)
            #expect(ASCII::ASCII.Code.a.isLetter == true)
            #expect(ASCII::ASCII.Code.z.isLetter == true)
            #expect((ASCII::ASCII.Code.z.underlying + 1).ascii.isLetter == false)
        }

        @Test
        func `Digit boundaries are precise`() {

            #expect((ASCII::ASCII.Code.`0`.underlying - 1).ascii.isDigit == false)
            #expect(ASCII::ASCII.Code.`0`.isDigit == true)
            #expect(ASCII::ASCII.Code.`9`.isDigit == true)
            #expect((ASCII::ASCII.Code.`9`.underlying + 1).ascii.isDigit == false)
        }

        @Test
        func `Printable boundaries are precise`() {

            #expect((ASCII::ASCII.Code.sp.underlying - 1).ascii.isPrintable == false)
            #expect(ASCII::ASCII.Code.sp.isPrintable == true)
            #expect(ASCII::ASCII.Code.tilde.isPrintable == true)
            #expect((ASCII::ASCII.Code.tilde.underlying + 1).ascii.isPrintable == false)
        }

        @Test
        func `Visible boundaries are precise`() {

            #expect(ASCII::ASCII.Code.sp.isVisible == false)
            #expect(ASCII::ASCII.Code.exclamationPoint.isVisible == true)
            #expect(ASCII::ASCII.Code.tilde.isVisible == true)
            #expect((ASCII::ASCII.Code.tilde.underlying + 1).ascii.isVisible == false)
        }
    }

    @Suite
    struct `Case conversion preserves bytes outside letter ranges` {
        @Test
        func `Uppercase conversion preserves an uppercase string`() {
            let codes: [ASCII.Code] = [.H, .E, .L, .L, .O]
            #expect(codes.ascii(case: .upper) == codes)
        }

        @Test
        func `Lowercase conversion preserves a lowercase string`() {
            let codes: [ASCII.Code] = [.h, .e, .l, .l, .o]
            #expect(codes.ascii(case: .lower) == codes)
        }

        @Test
        func `Case conversion preserves strings without letters`() {
            let codes: [ASCII.Code] = [.`0`, .`1`, .`2`, .sp, .exclamationPoint]
            #expect(codes.ascii(case: .upper) == codes)
            #expect(codes.ascii(case: .lower) == codes)
        }

        @Test
        func `Case conversion preserves control characters`() {
            let codes: [ASCII.Code] = [.nul, .htab, .lf, .cr, .esc, .del]
            #expect(codes.ascii(case: .upper) == codes)
            #expect(codes.ascii(case: .lower) == codes)
        }

        @Test
        func `Case conversion preserves symbols`() {
            let symbols: [ASCII.Code] = [
                .exclamationPoint, .commercialAt, .numberSign, .dollarSign,
                .percentSign, .circumflexAccent, .ampersand, .asterisk,
            ]
            #expect(symbols.ascii(case: .upper) == symbols)
            #expect(symbols.ascii(case: .lower) == symbols)
        }

        @Test
        func `Case conversion preserves an empty array`() {
            let empty: [ASCII.Code] = []
            #expect(empty.ascii(case: .upper) == [])
            #expect(empty.ascii(case: .lower) == [])
        }

        @Test
        func `Converting mixed letters and other characters preserves their structure`() {
            let codes: [ASCII.Code] = [.H, .e, .l, .`3`, .exclamationPoint]
            let upper = codes.ascii(case: .upper)
            #expect(upper == [.H, .E, .L, .`3`, .exclamationPoint])
        }

        @Test
        func `Case conversion respects the boundaries of both letter ranges`() {

            let nonLetters: [ASCII.Code] = [
                0x40,
                0x5B,
                0x60,
                0x7B,
            ]
            #expect(nonLetters.ascii(case: .upper) == nonLetters)
            #expect(nonLetters.ascii(case: .lower) == nonLetters)
        }

        @Test
        func `String case conversion works correctly`() {
            let str = "HeLLo123!"
            #expect(str.ascii(case: .upper) == "HELLO123!")
            #expect(str.ascii(case: .lower) == "hello123!")
        }
    }

    @Suite
    struct `Validation handles empty arrays and invalid byte positions` {
        @Test
        func `Empty array is valid ASCII`() {
            let empty: [Byte] = []
            #expect(isAllASCII(empty))
        }

        @Test
        func `Single NUL byte is valid`() {
            #expect(isAllASCII([ASCII::ASCII.Code.nul.byte]))
        }

        @Test
        func `Single DEL byte is valid`() {
            #expect(isAllASCII([ASCII::ASCII.Code.del.byte]))
        }

        @Test
        func `All zeros array is valid ASCII`() {
            let zeros: [Byte] = Array(repeating: ASCII::ASCII.Code.nul.byte, count: 1000)
            #expect(isAllASCII(zeros))
        }

        @Test
        func `All DEL array is valid ASCII`() {
            let dels: [Byte] = Array(repeating: ASCII::ASCII.Code.del.byte, count: 1000)
            #expect(isAllASCII(dels))
        }

        @Test
        func `Non-ASCII at start fails immediately`() {
            let bytes: [Byte] = [Byte(0x80), ASCII::ASCII.Code.A.byte, ASCII::ASCII.Code.B.byte, ASCII::ASCII.Code.C.byte]
            #expect(!isAllASCII(bytes))
        }

        @Test
        func `Validation detects a nonASCII byte at the end`() {
            let bytes: [Byte] = [ASCII::ASCII.Code.A.byte, ASCII::ASCII.Code.B.byte, ASCII::ASCII.Code.C.byte, Byte(0x80)]
            #expect(!isAllASCII(bytes))
        }

        @Test
        func `Validation detects a nonASCII byte in the middle`() {
            let bytes: [Byte] = [ASCII::ASCII.Code.A.byte, Byte(0x80), ASCII::ASCII.Code.B.byte]
            #expect(!isAllASCII(bytes))
        }

        @Test
        func `Every byte above the ASCII range is rejected`() {
            for value in UInt8(0x80)...UInt8(0xFF) {
                #expect(
                    !isAllASCII([Byte(bitPattern: value)]),
                    "Byte 0x\(String(value, radix: 16)) should be invalid"
                )
            }
        }

        @Test
        func `Every ASCII byte passes validation`() {

            let allASCII: [Byte] = (ASCII::ASCII.Code.nul.underlying...ASCII::ASCII.Code.del.underlying).map(
                Byte.init(bitPattern:)
            )
            #expect(isAllASCII(allASCII))
        }
    }

    @Suite
    struct `Character conversion accepts ASCII and rejects other characters` {
        @Test
        func `Non-ASCII character returns nil`() {
            #expect(UInt8(ascii: "é") == nil)
            #expect(UInt8(ascii: "ñ") == nil)
            #expect(UInt8(ascii: "ü") == nil)
        }

        @Test
        func `Emoji returns nil`() {
            #expect(UInt8(ascii: "😀") == nil)
            #expect(UInt8(ascii: "🎉") == nil)
            #expect(UInt8(ascii: "❤️") == nil)
        }

        @Test
        func `CJK characters return nil`() {
            #expect(UInt8(ascii: "中") == nil)
            #expect(UInt8(ascii: "文") == nil)
            #expect(UInt8(ascii: "日") == nil)
            #expect(UInt8(ascii: "本") == nil)
        }

        @Test
        func `Control characters convert correctly`() {
            #expect(UInt8(ascii: "\t") == ASCII::ASCII.Code.htab.underlying)
            #expect(UInt8(ascii: "\n") == ASCII::ASCII.Code.lf.underlying)
            #expect(UInt8(ascii: "\r") == ASCII::ASCII.Code.cr.underlying)
        }

        @Test
        func `All ASCII characters roundtrip`() {

            for byte in ASCII::ASCII.Code.nul.underlying...ASCII::ASCII.Code.del.underlying {
                let scalar = UnicodeScalar(byte)
                let char = Character(scalar)
                if let converted = UInt8(ascii: char) {
                    #expect(converted == byte, "Byte 0x\(String(byte, radix: 16)) failed roundtrip")
                }
            }
        }

        @Test
        func `Character predicate handles non-ASCII gracefully`() {
            let nonASCII = Character("é")
            #expect(nonASCII.ascii.isLetter == false)
            #expect(nonASCII.ascii.isDigit == false)
            #expect(nonASCII.ascii.isWhitespace == false)
        }
    }

    @Suite
    struct `Normalization handles empty and repeated line endings` {
        @Test
        func `Normalization preserves an empty string`() {
            #expect("".normalized(to: .lf).isEmpty)
            #expect("".normalized(to: .crlf).isEmpty)
        }

        @Test
        func `Normalization preserves text without line endings`() {
            let text = "Hello World"
            #expect(text.normalized(to: .lf) == text)
            #expect(text.normalized(to: .crlf) == text)
        }

        @Test
        func `Mixed line endings convert to the requested style`() {
            let mixed = "line1\r\nline2\nline3\rline4"
            #expect(mixed.normalized(to: .lf) == "line1\nline2\nline3\nline4")
            #expect(mixed.normalized(to: .crlf) == "line1\r\nline2\r\nline3\r\nline4")
        }

        @Test
        func `Normalization preserves consecutive CRLF pairs`() {
            let text = "line1\r\n\r\nline2"
            #expect(text.normalized(to: .lf) == "line1\n\nline2")
            #expect(text.normalized(to: .crlf) == "line1\r\n\r\nline2")
        }

        @Test
        func `Normalization preserves consecutive LF characters`() {
            let text = "line1\n\n\nline2"
            #expect(text.normalized(to: .lf) == text)
            #expect(text.normalized(to: .crlf) == "line1\r\n\r\n\r\nline2")
        }

        @Test
        func `Normalization preserves consecutive CR characters`() {
            let text = "line1\r\r\rline2"
            #expect(text.normalized(to: .lf) == "line1\n\n\nline2")
            #expect(text.normalized(to: .crlf) == "line1\r\n\r\n\r\nline2")
        }

        @Test
        func `A line ending at the start is handled`() {
            #expect("\ntext".normalized(to: .lf) == "\ntext")
            #expect("\r\ntext".normalized(to: .lf) == "\ntext")
            #expect("\ntext".normalized(to: .crlf) == "\r\ntext")
        }

        @Test
        func `A line ending at the end is handled`() {
            #expect("text\n".normalized(to: .lf) == "text\n")
            #expect("text\r\n".normalized(to: .lf) == "text\n")
            #expect("text\n".normalized(to: .crlf) == "text\r\n")
        }

        @Test
        func `Normalization handles strings containing only line endings`() {
            #expect("\n\n\n".normalized(to: .lf) == "\n\n\n")
            #expect("\r\n\r\n".normalized(to: .lf) == "\n\n")
            #expect("\n\n".normalized(to: .crlf) == "\r\n\r\n")
        }

        @Test
        func `Normalization handles a CR followed by a character other than LF`() {

            let text = "line1\rX"
            #expect(text.normalized(to: .lf) == "line1\nX")
            #expect(text.normalized(to: .crlf) == "line1\r\nX")
        }

        @Test
        func `Normalizing CRLF text to CRLF preserves it`() {
            let text = "line1\r\nline2\r\n"
            #expect(text.normalized(to: .crlf) == text)
        }

        @Test
        func `Normalizing LF text to LF preserves it`() {
            let text = "line1\nline2\n"
            #expect(text.normalized(to: .lf) == text)
        }
    }

    @Suite
    struct `String trimming preserves internal content` {
        @Test
        func `Trimming preserves an empty string`() {
            #expect("".trimming(.ascii.whitespaces).isEmpty)
        }

        @Test
        func `All whitespace string becomes empty`() {
            #expect("    ".trimming(.ascii.whitespaces).isEmpty)
            #expect("\t\t\t".trimming(.ascii.whitespaces).isEmpty)
            #expect("\n\n".trimming(.ascii.whitespaces).isEmpty)
            #expect(" \t\n\r ".trimming(.ascii.whitespaces).isEmpty)
        }

        @Test
        func `Trimming preserves strings without whitespace`() {
            let text = "HelloWorld"
            #expect(text.trimming(.ascii.whitespaces) == text)
        }

        @Test
        func `Trimming preserves internal whitespace`() {
            let text = "Hello World"
            #expect(text.trimming(.ascii.whitespaces) == text)
        }

        @Test
        func `Trimming removes mixed leading whitespace`() {
            let text = " \t\n  Hello"
            #expect(text.trimming(.ascii.whitespaces) == "Hello")
        }

        @Test
        func `Trimming removes mixed trailing whitespace`() {
            let text = "Hello  \n\t "
            #expect(text.trimming(.ascii.whitespaces) == "Hello")
        }

        @Test
        func `Trimming removes one leading space`() {
            #expect(" Hello".trimming(.ascii.whitespaces) == "Hello")
        }

        @Test
        func `Trimming removes one trailing space`() {
            #expect("Hello ".trimming(.ascii.whitespaces) == "Hello")
        }

        @Test
        func `Trimming preserves strings with only internal whitespace`() {
            let text = "A B C"
            #expect(text.trimming(.ascii.whitespaces) == text)
        }

        @Test
        func `Trimming preserves consecutive internal whitespace`() {
            let text = "A    B"
            #expect(text.trimming(.ascii.whitespaces) == text)
        }

        @Test
        func `Trimming removes outer whitespace while preserving internal whitespace`() {
            let text = "  Hello   World  "
            #expect(text.trimming(.ascii.whitespaces) == "Hello   World")
        }

        @Test
        func `Trimming removes the requested custom character set`() {
            let custom: Set<Character> = ["x", "y", "z"]
            #expect("xxHelloxx".trimming(custom) == "Hello")
            #expect("xyHellozyx".trimming(custom) == "Hello")
        }

        @Test
        func `Trimming with an empty set preserves the input`() {
            let text = "  Hello  "
            #expect(text.trimming(Set<Character>()) == text)
        }
    }

    @Suite
    struct `Whitespace sets contain the specified ASCII characters` {
        @Test
        func `INCITS whitespace set is exactly 4 characters`() {
            #expect(INCITS_4_1986.whitespaces.count == 4)
        }

        @Test
        func `Whitespace set is exactly 5 characters`() {
            #expect(Set<Character>.ascii.whitespaces.count == 5)
        }

        @Test
        func `Whitespace set contains only ASCII whitespace`() {

            let ws = INCITS_4_1986.whitespaces.compactMap { String(ascii: [$0.byte]) }
            #expect(ws.contains(" "))
            #expect(ws.contains("\t"))
            #expect(ws.contains("\n"))
            #expect(ws.contains("\r"))
            #expect(ws.count == 4)
        }

        @Test
        func `Whitespace set does not contain vertical tab`() {

            let vtab = Character(UnicodeScalar(0x0B))
            #expect(!Set<Character>.ascii.whitespaces.contains(vtab))
        }

        @Test
        func `Whitespace set does not contain form feed`() {

            let ff = Character(UnicodeScalar(0x0C))
            #expect(!Set<Character>.ascii.whitespaces.contains(ff))
        }

        @Test
        func `Whitespace set does not contain non-breaking space`() {

            let nbsp = Character("\u{00A0}")
            #expect(!Set<Character>.ascii.whitespaces.contains(nbsp))
        }

        @Test
        func `Whitespace codes distinguish space from control characters`() {

            #expect(ASCII::ASCII.Code.htab.isControl)
            #expect(ASCII::ASCII.Code.lf.isControl)
            #expect(ASCII::ASCII.Code.cr.isControl)
            #expect(!ASCII::ASCII.Code.sp.isControl)
        }
    }

    @Suite
    struct `ASCII constants match their specified values` {
        @Test
        func `Whitespaces constant has 4 bytes`() {
            #expect(INCITS_4_1986.whitespaces.count == 4)
            #expect(INCITS_4_1986.whitespaces.contains(ASCII::ASCII.Code.htab))
            #expect(INCITS_4_1986.whitespaces.contains(ASCII::ASCII.Code.lf))
            #expect(INCITS_4_1986.whitespaces.contains(ASCII::ASCII.Code.cr))
            #expect(INCITS_4_1986.whitespaces.contains(ASCII::ASCII.Code.sp))
        }

        @Test
        func `Crlf constant is exactly two bytes`() {
            #expect(INCITS_4_1986.Character.Control.crlf.count == 2)
            #expect(INCITS_4_1986.Character.Control.crlf == [ASCII::ASCII.Code.cr.underlying, ASCII::ASCII.Code.lf.underlying])
        }

        @Test
        func `Crlf order is CR then LF`() {
            #expect(INCITS_4_1986.Character.Control.crlf[0] == ASCII::ASCII.Code.cr.underlying)
            #expect(INCITS_4_1986.Character.Control.crlf[1] == ASCII::ASCII.Code.lf.underlying)
        }
    }
}
