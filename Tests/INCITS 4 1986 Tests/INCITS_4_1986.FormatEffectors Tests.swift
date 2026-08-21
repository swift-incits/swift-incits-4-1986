import Testing

@testable import INCITS_4_1986

extension INCITS_4_1986.FormatEffectors {
    @Suite struct `Format Effectors Tests` {
        @Suite struct Unit {
            @Test func `normalized converts LF to CRLF`() {
                let bytes: [UInt8] = [0x6C, 0x0A, 0x6D]
                #expect(INCITS_4_1986.normalized(bytes, to: .crlf) == [0x6C, 0x0D, 0x0A, 0x6D])
            }

            @Test func `normalized converts CRLF to LF`() {
                let bytes: [UInt8] = [0x6C, 0x0D, 0x0A, 0x6D]
                #expect(INCITS_4_1986.normalized(bytes, to: .lf) == [0x6C, 0x0A, 0x6D])
            }

            @Test func `normalized converts standalone CR to LF`() {
                let bytes: [UInt8] = [0x6C, 0x0D, 0x6D]
                #expect(INCITS_4_1986.normalized(bytes, to: .lf) == [0x6C, 0x0A, 0x6D])
            }

            @Test func `normalized converts mixed line endings to a single target style`() {
                let bytes: [UInt8] = Array("a\nb\r\nc\rd".utf8)
                let expected: [UInt8] = Array("a\nb\nc\nd".utf8)
                #expect(INCITS_4_1986.normalized(bytes, to: .lf) == expected)
            }

            @Test func `normalized preserves bytes that contain no line endings`() {
                let bytes: [UInt8] = Array("hello world".utf8)
                #expect(INCITS_4_1986.normalized(bytes, to: .crlf) == bytes)
            }

            @Test func `normalized is idempotent`() {
                let bytes: [UInt8] = Array("a\nb\r\nc\rd".utf8)
                let once = INCITS_4_1986.normalized(bytes, to: .crlf)
                let twice = INCITS_4_1986.normalized(once, to: .crlf)
                #expect(once == twice)
            }
        }

        @Suite struct `Edge Case` {
            @Test func `normalized on an empty collection returns an empty array`() {
                #expect(INCITS_4_1986.normalized([UInt8](), to: .crlf).isEmpty)
            }

            @Test func `normalized on a collection consisting only of a single line ending`() {
                #expect(INCITS_4_1986.normalized([0x0A], to: .crlf) == [0x0D, 0x0A])
                #expect(INCITS_4_1986.normalized([0x0D, 0x0A], to: .lf) == [0x0A])
            }

            @Test func `normalized converting CRLF to CRLF is a no-op`() {
                let bytes: [UInt8] = [0x6C, 0x0D, 0x0A, 0x6D]
                #expect(INCITS_4_1986.normalized(bytes, to: .crlf) == bytes)
            }

            @Test func `normalized handles a trailing CR with no following byte`() {
                let bytes: [UInt8] = [0x6C, 0x0D]
                #expect(INCITS_4_1986.normalized(bytes, to: .lf) == [0x6C, 0x0A])
            }
        }

        @Suite struct Integration {}
    }
}
