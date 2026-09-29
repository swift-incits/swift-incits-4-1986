import Testing

import ASCII
import Byte
import Standard_Library_Extensions
@testable import INCITS_4_1986

@Suite
struct `ASCII exposes the specified graphic character constants` {
    @Suite
    struct `Digit constants map zero through nine to their ASCII values` {
        @Test
        func `Digit constants expose zero through nine`() {
            #expect(ASCII::ASCII.Code.0.underlying == 0x30)
            #expect(ASCII::ASCII.Code.1.underlying == 0x31)
            #expect(ASCII::ASCII.Code.9.underlying == 0x39)
        }

        @Test(arguments: Array(0...9))
        func `Digit constants have the specified ASCII values`(digit: Int) {
            let char = Character("\(digit)")
            let byte = UInt8(ascii: char)!
            #expect(byte == 0x30 + UInt8(digit))
        }
    }

    @Suite
    struct `Letter constants cover both ASCII letter cases` {
        @Test
        func `Uppercase letter constants have the specified ASCII values`() {
            #expect(ASCII::ASCII.Code.A.underlying == 0x41)
            #expect(ASCII::ASCII.Code.Z.underlying == 0x5A)
        }

        @Test
        func `Lowercase letter constants have the specified ASCII values`() {
            #expect(ASCII::ASCII.Code.a.underlying == 0x61)
            #expect(ASCII::ASCII.Code.z.underlying == 0x7A)
        }

        @Test(arguments: Array(zip("ABCDEFGHIJKLMNOPQRSTUVWXYZ", ASCII::ASCII.Code.A.underlying...ASCII::ASCII.Code.Z.underlying)))
        func `Every uppercase letter has the specified ASCII byte`(char: Character, expected: UInt8) {
            let byte = UInt8(ascii: char)!
            #expect(
                byte == expected,
                "Character '\(char)' should have value 0x\(String(expected, radix: 16))"
            )
        }

        @Test(arguments: Array(zip("abcdefghijklmnopqrstuvwxyz", ASCII::ASCII.Code.a.underlying...ASCII::ASCII.Code.z.underlying)))
        func `Every lowercase letter has the specified ASCII byte`(char: Character, expected: UInt8) {
            let byte = UInt8(ascii: char)!
            #expect(
                byte == expected,
                "Character '\(char)' should have value 0x\(String(expected, radix: 16))"
            )
        }
    }

    @Suite
    struct `Punctuation constants have the specified ASCII values` {
        @Test
        func `Common punctuation constants have the specified ASCII values`() {
            #expect(ASCII::ASCII.Code.exclamationPoint.underlying == 0x21)
            #expect(ASCII::ASCII.Code.period.underlying == 0x2E)
            #expect(ASCII::ASCII.Code.comma.underlying == 0x2C)
            #expect(ASCII::ASCII.Code.questionMark.underlying == 0x3F)
        }

        @Test
        func `Bracket and parenthesis constants have the specified ASCII values`() {
            #expect(ASCII::ASCII.Code.leftParenthesis.underlying == 0x28)
            #expect(ASCII::ASCII.Code.rightParenthesis.underlying == 0x29)
            #expect(ASCII::ASCII.Code.leftBracket.underlying == 0x5B)
            #expect(ASCII::ASCII.Code.rightBracket.underlying == 0x5D)
        }
    }
}
