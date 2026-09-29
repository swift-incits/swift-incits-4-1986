import Testing

@testable import INCITS_4_1986

extension INCITS_4_1986 {
    @Suite struct `INCITS validates the seven bit ASCII range` {
        @Suite struct `INCITS validation provides its declared operations` {
            @Test func `IsASCII is true for every byte below 0x80`() {
                #expect(INCITS_4_1986.isASCII(0x00))
                #expect(INCITS_4_1986.isASCII(0x41))
                #expect(INCITS_4_1986.isASCII(0x7F))
            }

            @Test func `IsASCII is false for every byte at or above 0x80`() {
                #expect(!INCITS_4_1986.isASCII(0x80))
                #expect(!INCITS_4_1986.isASCII(0xFF))
            }

            @Test func `IsAllASCII is true when every byte is in range`() {
                #expect(INCITS_4_1986.isAllASCII([UInt8]("Hello".utf8)))
            }

            @Test func `IsAllASCII is false when any byte is out of range`() {
                #expect(!INCITS_4_1986.isAllASCII([0x48, 0x80, 0x49]))
            }

            @Test func `IsAllASCII is vacuously true for an empty collection`() {
                #expect(INCITS_4_1986.isAllASCII([UInt8]()))
            }
        }

        @Suite struct `INCITS validation handles empty inputs and boundary values` {
            @Test func `Boundary byte 0x7F is ASCII and 0x80 is not`() {
                #expect(INCITS_4_1986.isASCII(0x7F))
                #expect(!INCITS_4_1986.isASCII(0x80))
            }

            @Test func `Boundary byte 0x00 is ASCII`() {
                #expect(INCITS_4_1986.isASCII(0x00))
            }
        }

        @Suite struct `INCITS validation integrates with its consumers` {}
    }
}
