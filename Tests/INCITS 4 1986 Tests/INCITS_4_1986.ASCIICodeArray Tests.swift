import Testing

@testable import INCITS_4_1986

@Suite struct `Code arrays provide INCITS ASCII conversions` {
    @Suite struct `ASCII collection adapters provides its declared operations` {
        @Test func `Init ascii string succeeds for all-ASCII input`() {
            let codes = [ASCII::ASCII.Code](ascii: "Hi!")
            #expect(codes != nil)
            #expect(codes?.count == 3)
        }

        @Test func `Init ascii string fails for non-ASCII input`() {
            #expect([ASCII::ASCII.Code](ascii: "café") == nil)
        }

        @Test func `Init ascii lineEnding produces the matching code sequence`() {
            #expect([ASCII::ASCII.Code](ascii: .lf) == [.lf])
            #expect([ASCII::ASCII.Code](ascii: .cr) == [.cr])
            #expect([ASCII::ASCII.Code](ascii: .crlf) == [.cr, .lf])
        }

        @Test func `Static ascii unchecked decodes without validation`() {
            #expect(
                [ASCII::ASCII.Code].ascii.unchecked("Hi") == [
                    ASCII::ASCII.Code
                ](ascii: "Hi")!
            )
        }

        @Test func `Static ascii crlf is CR followed by LF`() {
            #expect([ASCII::ASCII.Code].ascii.crlf == [.cr, .lf])
        }

        @Test func `Static ascii whitespaces contains the four INCITS 4-1986 whitespace codes`() {
            let whitespaces = [ASCII::ASCII.Code].ascii.whitespaces
            #expect(whitespaces.contains(.sp))
            #expect(whitespaces.contains(.htab))
            #expect(whitespaces.contains(.lf))
            #expect(whitespaces.contains(.cr))
            #expect(whitespaces.count == 4)
        }
    }

    @Suite struct `ASCII collection adapters handles empty inputs and boundary values` {
        @Test func `Init ascii string succeeds for an empty string`() {
            #expect([ASCII::ASCII.Code](ascii: "") == [])
        }

        @Test func `Static ascii unchecked on an empty string is empty`() {
            #expect([ASCII::ASCII.Code].ascii.unchecked("").isEmpty)
        }

        @Test func `Static ascii whitespaces does not contain a non-whitespace code`() {
            #expect(![ASCII::ASCII.Code].ascii.whitespaces.contains(.A))
        }
    }

    @Suite struct `ASCII collection adapters integrates with its consumers` {}
}

@Suite struct `Character sets provide INCITS whitespace operations` {
    @Suite struct `ASCII collection adapters provides its declared operations` {
        @Test func `Whitespaces contains SPACE HTAB LF CR and CRLF grapheme`() {
            #expect(Set<Character>.ascii.whitespaces.contains(" "))
            #expect(Set<Character>.ascii.whitespaces.contains("\t"))
            #expect(Set<Character>.ascii.whitespaces.contains("\n"))
            #expect(Set<Character>.ascii.whitespaces.contains("\r"))
            #expect(Set<Character>.ascii.whitespaces.contains("\r\n"))
        }

        @Test func `Whitespaces does not contain a non-whitespace character`() {
            #expect(!Set<Character>.ascii.whitespaces.contains("a"))
        }

        @Test func `IsWhitespace recognizes the CRLF grapheme cluster as a single whitespace unit`() {
            #expect(Set<Character>.ASCII.isWhitespace("\r\n"))
        }

        @Test func `IsWhitespace recognizes individual ASCII whitespace characters`() {
            #expect(Set<Character>.ASCII.isWhitespace(" "))
            #expect(Set<Character>.ASCII.isWhitespace("\t"))
        }

        @Test func `IsWhitespace rejects a non-whitespace character`() {
            #expect(!Set<Character>.ASCII.isWhitespace("a"))
        }
    }

    @Suite struct `ASCII collection adapters handles empty inputs and boundary values` {
        @Test func `IsWhitespace rejects a non-ASCII character even if it is Unicode whitespace`() {
            #expect(!Set<Character>.ASCII.isWhitespace("\u{00A0}"))
        }
    }

    @Suite struct `ASCII collection adapters integrates with its consumers` {}
}
