import ASCII
import Byte
import Standard_Library_Extensions
import Testing

@testable import INCITS_4_1986

@Suite
struct `ASCII digit values decode decimal and hexadecimal characters` {
    @Suite
    struct `Decimal digit values decode zero through nine` {
        @Test
        func `Digit decoding parses digit '0' as 0`() {
            #expect(ASCII.Code(INCITS_4_1986.Character.Graphic.`0`).digitValue == 0)
        }

        @Test
        func `Digit decoding parses digit '1' as 1`() {
            #expect(ASCII.Code(INCITS_4_1986.Character.Graphic.`1`).digitValue == 1)
        }

        @Test
        func `Digit decoding parses digit '9' as 9`() {
            #expect(ASCII.Code(INCITS_4_1986.Character.Graphic.`9`).digitValue == 9)
        }

        @Test
        func `Digit decoding parses all digits 0-9 correctly`() {
            let digits: [(UInt8, UInt8)] = [
                (INCITS_4_1986.Character.Graphic.`0`, 0),
                (INCITS_4_1986.Character.Graphic.`1`, 1),
                (INCITS_4_1986.Character.Graphic.`2`, 2),
                (INCITS_4_1986.Character.Graphic.`3`, 3),
                (INCITS_4_1986.Character.Graphic.`4`, 4),
                (INCITS_4_1986.Character.Graphic.`5`, 5),
                (INCITS_4_1986.Character.Graphic.`6`, 6),
                (INCITS_4_1986.Character.Graphic.`7`, 7),
                (INCITS_4_1986.Character.Graphic.`8`, 8),
                (INCITS_4_1986.Character.Graphic.`9`, 9),
            ]

            for (digitByte, expectedValue) in digits {
                #expect(ASCII.Code(digitByte).digitValue == expectedValue)
            }
        }

        @Test(arguments: [
            INCITS_4_1986.Character.Graphic.A,
            INCITS_4_1986.Character.Graphic.a,
            INCITS_4_1986.SPACE.sp,
            UInt8(0x2F),
            UInt8(0x3A),
        ])
        func `Digit decoding returns nil for non-digit bytes`(byte: UInt8) {
            #expect(ASCII.Code(byte).digitValue == nil)
        }
    }

    @Suite
    struct `Hexadecimal digit values decode zero through fifteen` {
        @Test
        func `Digit decoding parses hex digit '0' as 0`() {
            #expect(ASCII.Code(INCITS_4_1986.Character.Graphic.`0`).hexValue == 0)
        }

        @Test
        func `Digit decoding parses hex digit '9' as 9`() {
            #expect(ASCII.Code(INCITS_4_1986.Character.Graphic.`9`).hexValue == 9)
        }

        @Test
        func `Digit decoding parses hex digit 'A' as 10`() {
            #expect(ASCII.Code(INCITS_4_1986.Character.Graphic.A).hexValue == 10)
        }

        @Test
        func `Digit decoding parses hex digit 'F' as 15`() {
            #expect(ASCII.Code(INCITS_4_1986.Character.Graphic.F).hexValue == 15)
        }

        @Test
        func `Digit decoding parses hex digit 'a' as 10`() {
            #expect(ASCII.Code(INCITS_4_1986.Character.Graphic.a).hexValue == 10)
        }

        @Test
        func `Digit decoding parses hex digit 'f' as 15`() {
            #expect(ASCII.Code(INCITS_4_1986.Character.Graphic.f).hexValue == 15)
        }

        @Test
        func `Digit decoding parses all decimal digits 0-9`() {
            for i in UInt8(0)...UInt8(9) {
                let digitByte = INCITS_4_1986.Character.Graphic.`0` + i
                #expect(ASCII.Code(digitByte).hexValue == i)
            }
        }

        @Test
        func `Digit decoding parses all uppercase hex letters A-F`() {
            for i in UInt8(0)...UInt8(5) {
                let letterByte = INCITS_4_1986.Character.Graphic.A + i
                #expect(ASCII.Code(letterByte).hexValue == 10 + i)
            }
        }

        @Test
        func `Digit decoding parses all lowercase hex letters a-f`() {
            for i in UInt8(0)...UInt8(5) {
                let letterByte = INCITS_4_1986.Character.Graphic.a + i
                #expect(ASCII.Code(letterByte).hexValue == 10 + i)
            }
        }

        @Test(arguments: [
            INCITS_4_1986.Character.Graphic.G,
            INCITS_4_1986.Character.Graphic.g,
            INCITS_4_1986.Character.Graphic.Z,
            INCITS_4_1986.Character.Graphic.z,
            INCITS_4_1986.SPACE.sp,
            INCITS_4_1986.Character.Control.lf,
        ])
        func `Digit decoding returns nil for non-hex bytes`(byte: UInt8) {
            #expect(ASCII.Code(byte).hexValue == nil)
        }
    }

    @Suite
    struct `Digit conversion preserves every representable digit value` {
        @Test
        func `Decimal digits preserve values zero through nine`() {
            for value in UInt8(0)...UInt8(9) {
                let digitByte = INCITS_4_1986.Character.Graphic.`0` + value
                let parsed = ASCII.Code(digitByte).digitValue
                #expect(parsed == value)
            }
        }

        @Test
        func `Uppercase hexadecimal digits preserve values zero through fifteen`() {
            let hexChars: [UInt8] = [
                INCITS_4_1986.Character.Graphic.`0`,
                INCITS_4_1986.Character.Graphic.`1`,
                INCITS_4_1986.Character.Graphic.`2`,
                INCITS_4_1986.Character.Graphic.`3`,
                INCITS_4_1986.Character.Graphic.`4`,
                INCITS_4_1986.Character.Graphic.`5`,
                INCITS_4_1986.Character.Graphic.`6`,
                INCITS_4_1986.Character.Graphic.`7`,
                INCITS_4_1986.Character.Graphic.`8`,
                INCITS_4_1986.Character.Graphic.`9`,
                INCITS_4_1986.Character.Graphic.A,
                INCITS_4_1986.Character.Graphic.B,
                INCITS_4_1986.Character.Graphic.C,
                INCITS_4_1986.Character.Graphic.D,
                INCITS_4_1986.Character.Graphic.E,
                INCITS_4_1986.Character.Graphic.F,
            ]

            for (index, hexChar) in hexChars.enumerated() {
                let parsed = ASCII.Code(hexChar).hexValue
                #expect(parsed == UInt8(index))
            }
        }

        @Test
        func `Lowercase hexadecimal digits preserve values zero through fifteen`() {
            let hexChars: [UInt8] = [
                INCITS_4_1986.Character.Graphic.`0`,
                INCITS_4_1986.Character.Graphic.`1`,
                INCITS_4_1986.Character.Graphic.`2`,
                INCITS_4_1986.Character.Graphic.`3`,
                INCITS_4_1986.Character.Graphic.`4`,
                INCITS_4_1986.Character.Graphic.`5`,
                INCITS_4_1986.Character.Graphic.`6`,
                INCITS_4_1986.Character.Graphic.`7`,
                INCITS_4_1986.Character.Graphic.`8`,
                INCITS_4_1986.Character.Graphic.`9`,
                INCITS_4_1986.Character.Graphic.a,
                INCITS_4_1986.Character.Graphic.b,
                INCITS_4_1986.Character.Graphic.c,
                INCITS_4_1986.Character.Graphic.d,
                INCITS_4_1986.Character.Graphic.e,
                INCITS_4_1986.Character.Graphic.f,
            ]

            for (index, hexChar) in hexChars.enumerated() {
                let parsed = ASCII.Code(hexChar).hexValue
                #expect(parsed == UInt8(index))
            }
        }
    }

    @Suite
    struct `Hexadecimal letter cases decode to the same values` {
        @Test
        func `Uppercase and lowercase hex letters parse to same value`() {
            for i in UInt8(0)...UInt8(5) {
                let upperByte = INCITS_4_1986.Character.Graphic.A + i
                let lowerByte = INCITS_4_1986.Character.Graphic.a + i

                let upperValue = ASCII.Code(upperByte).hexValue
                let lowerValue = ASCII.Code(lowerByte).hexValue

                #expect(upperValue == lowerValue)
                #expect(upperValue == 10 + i)
            }
        }
    }
}
