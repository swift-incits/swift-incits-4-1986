import Testing

@testable import INCITS_4_1986

extension INCITS_4_1986 {
    @Suite struct `Validation Tests` {
        @Suite struct Unit {
            @Test func `isASCII is true for every byte below 0x80`() {
                #expect(INCITS_4_1986.isASCII(0x00))
                #expect(INCITS_4_1986.isASCII(0x41))
                #expect(INCITS_4_1986.isASCII(0x7F))
            }

            @Test func `isASCII is false for every byte at or above 0x80`() {
                #expect(!INCITS_4_1986.isASCII(0x80))
                #expect(!INCITS_4_1986.isASCII(0xFF))
            }

            @Test func `isAllASCII is true when every byte is in range`() {
                #expect(INCITS_4_1986.isAllASCII([UInt8]("Hello".utf8)))
            }

            @Test func `isAllASCII is false when any byte is out of range`() {
                #expect(!INCITS_4_1986.isAllASCII([0x48, 0x80, 0x49]))
            }

            @Test func `isAllASCII is vacuously true for an empty collection`() {
                #expect(INCITS_4_1986.isAllASCII([UInt8]()))
            }
        }

        @Suite struct `Edge Case` {
            @Test func `boundary byte 0x7F is ASCII and 0x80 is not`() {
                #expect(INCITS_4_1986.isASCII(0x7F))
                #expect(!INCITS_4_1986.isASCII(0x80))
            }

            @Test func `boundary byte 0x00 is ASCII`() {
                #expect(INCITS_4_1986.isASCII(0x00))
            }
        }

        @Suite struct Integration {}
    }
}
