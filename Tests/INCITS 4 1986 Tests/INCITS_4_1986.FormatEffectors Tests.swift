import Testing

@testable import INCITS_4_1986

extension INCITS_4_1986.FormatEffectors {
    @Suite struct `INCITS normalization delegates to core ASCII` {
        @Suite struct `INCITS normalization provides its declared operations` {
            @Test func `Normalized converts LF to CRLF`() {
                let bytes: [UInt8] = [0x6C, 0x0A, 0x6D]
                #expect(INCITS_4_1986.normalized(bytes, to: .crlf) == [0x6C, 0x0D, 0x0A, 0x6D])
            }

            @Test func `Normalized converts CRLF to LF`() {
                let bytes: [UInt8] = [0x6C, 0x0D, 0x0A, 0x6D]
                #expect(INCITS_4_1986.normalized(bytes, to: .lf) == [0x6C, 0x0A, 0x6D])
            }

            @Test func `Normalized converts standalone CR to LF`() {
                let bytes: [UInt8] = [0x6C, 0x0D, 0x6D]
                #expect(INCITS_4_1986.normalized(bytes, to: .lf) == [0x6C, 0x0A, 0x6D])
            }

            @Test func `Normalized converts mixed line endings to a single target style`() {
                let bytes: [UInt8] = Array("a\nb\r\nc\rd".utf8)
                let expected: [UInt8] = Array("a\nb\nc\nd".utf8)
                #expect(INCITS_4_1986.normalized(bytes, to: .lf) == expected)
            }

            @Test func `Normalized preserves bytes that contain no line endings`() {
                let bytes: [UInt8] = Array("hello world".utf8)
                #expect(INCITS_4_1986.normalized(bytes, to: .crlf) == bytes)
            }

            @Test func `Normalized is idempotent`() {
                let bytes: [UInt8] = Array("a\nb\r\nc\rd".utf8)
                let once = INCITS_4_1986.normalized(bytes, to: .crlf)
                let twice = INCITS_4_1986.normalized(once, to: .crlf)
                #expect(once == twice)
            }
        }

        @Suite struct `INCITS normalization handles empty inputs and boundary values` {
            @Test func `Normalized on an empty collection returns an empty array`() {
                #expect(INCITS_4_1986.normalized([UInt8](), to: .crlf).isEmpty)
            }

            @Test func `Normalization handles a collection containing only one line ending`() {
                #expect(INCITS_4_1986.normalized([0x0A], to: .crlf) == [0x0D, 0x0A])
                #expect(INCITS_4_1986.normalized([0x0D, 0x0A], to: .lf) == [0x0A])
            }

            @Test func `Normalized converting CRLF to CRLF is a no-op`() {
                let bytes: [UInt8] = [0x6C, 0x0D, 0x0A, 0x6D]
                #expect(INCITS_4_1986.normalized(bytes, to: .crlf) == bytes)
            }

            @Test func `Normalized handles a trailing CR with no following byte`() {
                let bytes: [UInt8] = [0x6C, 0x0D]
                #expect(INCITS_4_1986.normalized(bytes, to: .lf) == [0x6C, 0x0A])
            }
        }

        @Suite struct `INCITS normalization integrates with its consumers` {}
    }
}
