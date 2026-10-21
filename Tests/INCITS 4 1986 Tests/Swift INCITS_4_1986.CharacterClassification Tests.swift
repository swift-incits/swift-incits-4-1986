import ASCII
import Byte
import Standard_Library_Extensions
import Testing

@testable import INCITS_4_1986

@Suite
struct `INCITS classifies ASCII character codes` {
    @Suite
    struct `Whitespace classification recognizes the ASCII whitespace set` {
        @Test(arguments: [
            INCITS_4_1986.SPACE.sp,
            INCITS_4_1986.Character.Control.htab,
            INCITS_4_1986.Character.Control.lf,
            INCITS_4_1986.Character.Control.cr,
        ])
        func `The predicate recognizes ASCII whitespace characters`(byte: UInt8) {
            #expect(INCITS_4_1986.Classification.isWhitespace(byte))
        }

        @Test(arguments: [
            INCITS_4_1986.Character.Graphic.A,
            INCITS_4_1986.Character.Graphic.`0`,
            INCITS_4_1986.Character.Control.nul,
            INCITS_4_1986.Character.Graphic.exclamationPoint,
        ])
        func `The predicate rejects non-whitespace characters`(byte: UInt8) {
            #expect(!INCITS_4_1986.Classification.isWhitespace(byte))
        }
    }

    @Suite
    struct `Control classification recognizes the ASCII control ranges` {
        @Test(
            arguments: Array(
                INCITS_4_1986.Character.Control.nul...INCITS_4_1986.Character.Control.us
            )
        )
        func `The predicate recognizes control characters 0x00-0x1F`(byte: UInt8) {
            #expect(INCITS_4_1986.Classification.isControl(byte))
        }

        @Test
        func `The predicate recognizes DEL as control character`() {
            #expect(INCITS_4_1986.Classification.isControl(INCITS_4_1986.Character.Control.del))
        }

        @Test(arguments: Array(INCITS_4_1986.SPACE.sp...UInt8(0x7E)))
        func `The predicate rejects printable characters as control`(byte: UInt8) {
            #expect(!INCITS_4_1986.Classification.isControl(byte))
        }
    }

    @Suite
    struct `Digit classification recognizes decimal digits` {
        @Test(
            arguments: Array(
                INCITS_4_1986.Character.Graphic.`0`...INCITS_4_1986.Character.Graphic.`9`
            )
        )
        func `The predicate recognizes ASCII digits 0-9`(byte: UInt8) {
            #expect(INCITS_4_1986.Classification.isDigit(byte))
        }

        @Test(arguments: [
            INCITS_4_1986.Character.Graphic.A,
            INCITS_4_1986.Character.Graphic.a,
            INCITS_4_1986.SPACE.sp,
            UInt8(0x2F),
            UInt8(0x3A),
        ])
        func `The predicate rejects non-digit characters`(byte: UInt8) {
            #expect(!INCITS_4_1986.Classification.isDigit(byte))
        }
    }

    @Suite
    struct `Letter classification distinguishes ASCII letter cases` {
        @Test(
            arguments: Array(INCITS_4_1986.Character.Graphic.A...INCITS_4_1986.Character.Graphic.Z)
        )
        func `The predicate recognizes uppercase letters A-Z`(byte: UInt8) {
            #expect(INCITS_4_1986.Classification.isLetter(byte))
            #expect(INCITS_4_1986.Classification.isUppercase(byte))
            #expect(!INCITS_4_1986.Classification.isLowercase(byte))
        }

        @Test(
            arguments: Array(INCITS_4_1986.Character.Graphic.a...INCITS_4_1986.Character.Graphic.z)
        )
        func `The predicate recognizes lowercase letters a-z`(byte: UInt8) {
            #expect(INCITS_4_1986.Classification.isLetter(byte))
            #expect(INCITS_4_1986.Classification.isLowercase(byte))
            #expect(!INCITS_4_1986.Classification.isUppercase(byte))
        }

        @Test(arguments: [
            INCITS_4_1986.Character.Graphic.`0`,
            INCITS_4_1986.SPACE.sp,
            INCITS_4_1986.Character.Graphic.exclamationPoint,
            UInt8(0x40),
            UInt8(0x5B),
            UInt8(0x60),
            UInt8(0x7B),
        ])
        func `The predicate rejects non-letter characters`(byte: UInt8) {
            #expect(!INCITS_4_1986.Classification.isLetter(byte))
        }
    }

    @Suite
    struct `Alphanumeric classification accepts letters and digits` {
        @Test(
            arguments:
                Array(INCITS_4_1986.Character.Graphic.`0`...INCITS_4_1986.Character.Graphic.`9`)
                + Array(INCITS_4_1986.Character.Graphic.A...INCITS_4_1986.Character.Graphic.Z)
                + Array(INCITS_4_1986.Character.Graphic.a...INCITS_4_1986.Character.Graphic.z)
        )
        func `The predicate recognizes alphanumeric characters`(byte: UInt8) {
            #expect(INCITS_4_1986.Classification.isAlphanumeric(byte))
        }

        @Test(arguments: [
            INCITS_4_1986.SPACE.sp,
            INCITS_4_1986.Character.Graphic.exclamationPoint,
            INCITS_4_1986.Character.Control.lf,
            UInt8(0x40),
            UInt8(0x5B),
            UInt8(0x60),
        ])
        func `The predicate rejects non-alphanumeric characters`(byte: UInt8) {
            #expect(!INCITS_4_1986.Classification.isAlphanumeric(byte))
        }
    }

    @Suite
    struct `Visible classification accepts graphic characters` {
        @Test(arguments: Array(INCITS_4_1986.Character.Graphic.exclamationPoint...UInt8(0x7E)))
        func `The predicate recognizes visible characters 0x21-0x7E`(byte: UInt8) {
            #expect(INCITS_4_1986.Classification.isVisible(byte))
        }

        @Test
        func `The predicate rejects SPACE as visible`() {
            #expect(!INCITS_4_1986.Classification.isVisible(INCITS_4_1986.SPACE.sp))
        }

        @Test(
            arguments: Array(
                INCITS_4_1986.Character.Control.nul...INCITS_4_1986.Character.Control.us
            ) + [
                INCITS_4_1986.Character.Control.del
            ]
        )
        func `The predicate rejects control characters as visible`(byte: UInt8) {
            #expect(!INCITS_4_1986.Classification.isVisible(byte))
        }
    }

    @Suite
    struct `Printable classification includes space and graphic characters` {
        @Test(arguments: Array(INCITS_4_1986.SPACE.sp...UInt8(0x7E)))
        func `The predicate recognizes printable characters 0x20-0x7E`(byte: UInt8) {
            #expect(INCITS_4_1986.Classification.isPrintable(byte))
        }

        @Test
        func `The predicate includes SPACE as printable`() {
            #expect(INCITS_4_1986.Classification.isPrintable(INCITS_4_1986.SPACE.sp))
        }

        @Test(
            arguments: Array(
                INCITS_4_1986.Character.Control.nul...INCITS_4_1986.Character.Control.us
            ) + [
                INCITS_4_1986.Character.Control.del
            ]
        )
        func `The predicate rejects control characters as printable`(byte: UInt8) {
            #expect(!INCITS_4_1986.Classification.isPrintable(byte))
        }
    }

    @Suite
    struct `Hexadecimal classification accepts decimal digits and letters A through F` {
        @Test(
            arguments: Array(
                INCITS_4_1986.Character.Graphic.`0`...INCITS_4_1986.Character.Graphic.`9`
            )
        )
        func `The predicate recognizes hex digits 0-9`(byte: UInt8) {
            #expect(INCITS_4_1986.Classification.isHexDigit(byte))
        }

        @Test(
            arguments: Array(INCITS_4_1986.Character.Graphic.A...INCITS_4_1986.Character.Graphic.F)
        )
        func `The predicate recognizes hex digits A-F`(byte: UInt8) {
            #expect(INCITS_4_1986.Classification.isHexDigit(byte))
        }

        @Test(
            arguments: Array(INCITS_4_1986.Character.Graphic.a...INCITS_4_1986.Character.Graphic.f)
        )
        func `The predicate recognizes hex digits a-f`(byte: UInt8) {
            #expect(INCITS_4_1986.Classification.isHexDigit(byte))
        }

        @Test(arguments: [
            INCITS_4_1986.Character.Graphic.G,
            INCITS_4_1986.Character.Graphic.g,
            INCITS_4_1986.Character.Graphic.Z,
            INCITS_4_1986.Character.Graphic.z,
            INCITS_4_1986.SPACE.sp,
        ])
        func `The predicate rejects non-hex characters`(byte: UInt8) {
            #expect(!INCITS_4_1986.Classification.isHexDigit(byte))
        }
    }

    @Suite
    struct `Character classifications obey their logical relationships` {
        @Test
        func `Control and printable are mutually exclusive`() {
            for byte in UInt8(0)...UInt8(127) {
                let isControl = INCITS_4_1986.Classification.isControl(byte)
                let isPrintable = INCITS_4_1986.Classification.isPrintable(byte)
                #expect(
                    isControl != isPrintable,
                    "Byte \(byte) should be either control or printable, not both"
                )
            }
        }

        @Test
        func `Every ASCII byte is either control or printable`() {
            for byte in UInt8(0)...UInt8(127) {
                let isControl = INCITS_4_1986.Classification.isControl(byte)
                let isPrintable = INCITS_4_1986.Classification.isPrintable(byte)
                #expect(
                    isControl || isPrintable,
                    "Byte \(byte) must be either control or printable"
                )
            }
        }

        @Test
        func `Uppercase and lowercase are mutually exclusive`() {
            for byte in UInt8(0)...UInt8(127) {
                let isUpper = INCITS_4_1986.Classification.isUppercase(byte)
                let isLower = INCITS_4_1986.Classification.isLowercase(byte)
                #expect(
                    !(isUpper && isLower),
                    "Byte \(byte) cannot be both uppercase and lowercase"
                )
            }
        }

        @Test
        func `Letter implies alphanumeric`() {
            for byte in UInt8(0)...UInt8(127) {
                if INCITS_4_1986.Classification.isLetter(byte) {
                    #expect(INCITS_4_1986.Classification.isAlphanumeric(byte))
                }
            }
        }

        @Test
        func `Digit implies alphanumeric`() {
            for byte in UInt8(0)...UInt8(127) {
                if INCITS_4_1986.Classification.isDigit(byte) {
                    #expect(INCITS_4_1986.Classification.isAlphanumeric(byte))
                }
            }
        }
    }

    @Suite
    struct `Classification ranges include exactly their boundary values` {
        @Test
        func `Digit boundaries are precise`() {
            #expect(!INCITS_4_1986.Classification.isDigit(UInt8(0x2F)))
            #expect(INCITS_4_1986.Classification.isDigit(UInt8(0x30)))
            #expect(INCITS_4_1986.Classification.isDigit(UInt8(0x39)))
            #expect(!INCITS_4_1986.Classification.isDigit(UInt8(0x3A)))
        }

        @Test
        func `Letter boundaries are precise`() {
            #expect(!INCITS_4_1986.Classification.isLetter(UInt8(0x40)))
            #expect(INCITS_4_1986.Classification.isLetter(UInt8(0x41)))
            #expect(INCITS_4_1986.Classification.isLetter(UInt8(0x5A)))
            #expect(!INCITS_4_1986.Classification.isLetter(UInt8(0x5B)))
            #expect(!INCITS_4_1986.Classification.isLetter(UInt8(0x60)))
            #expect(INCITS_4_1986.Classification.isLetter(UInt8(0x61)))
            #expect(INCITS_4_1986.Classification.isLetter(UInt8(0x7A)))
            #expect(!INCITS_4_1986.Classification.isLetter(UInt8(0x7B)))
        }

        @Test
        func `Visible boundaries are precise`() {
            #expect(!INCITS_4_1986.Classification.isVisible(UInt8(0x20)))
            #expect(INCITS_4_1986.Classification.isVisible(UInt8(0x21)))
            #expect(INCITS_4_1986.Classification.isVisible(UInt8(0x7E)))
            #expect(!INCITS_4_1986.Classification.isVisible(UInt8(0x7F)))
        }

        @Test
        func `Printable boundaries are precise`() {
            #expect(!INCITS_4_1986.Classification.isPrintable(UInt8(0x1F)))
            #expect(INCITS_4_1986.Classification.isPrintable(UInt8(0x20)))
            #expect(INCITS_4_1986.Classification.isPrintable(UInt8(0x7E)))
            #expect(!INCITS_4_1986.Classification.isPrintable(UInt8(0x7F)))
        }
    }
}
