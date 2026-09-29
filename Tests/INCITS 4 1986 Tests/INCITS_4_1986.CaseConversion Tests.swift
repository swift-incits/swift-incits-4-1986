import Testing

@testable import INCITS_4_1986

extension INCITS_4_1986 {
    @Suite struct `INCITS conversion changes only ASCII letter case` {
        @Suite struct `INCITS case conversion provides its declared operations` {
            @Test func `Converting a string to upper case transforms letters only`() {
                #expect(INCITS_4_1986.convert("hello World 123!", to: .upper) == "HELLO WORLD 123!")
            }

            @Test func `Converting a string to lower case transforms letters only`() {
                #expect(INCITS_4_1986.convert("HELLO World 123!", to: .lower) == "hello world 123!")
            }

            @Test func `Converting a code array to upper case transforms letters only`() {
                let codes = [ASCII::ASCII.Code](ascii: "hello!")!
                let expected = [ASCII::ASCII.Code](ascii: "HELLO!")!
                #expect(INCITS_4_1986.convert(codes, to: .upper) == expected)
            }

            @Test func `Converting a code array to lower case transforms letters only`() {
                let codes = [ASCII::ASCII.Code](ascii: "HELLO!")!
                let expected = [ASCII::ASCII.Code](ascii: "hello!")!
                #expect(INCITS_4_1986.convert(codes, to: .lower) == expected)
            }
        }

        @Suite struct `INCITS case conversion handles empty inputs and boundary values` {
            @Test func `Converting preserves non-letter characters unchanged`() {
                #expect(INCITS_4_1986.convert("123-456", to: .upper) == "123-456")
            }

            @Test func `Converting non-ASCII text preserves it exactly`() {
                #expect(INCITS_4_1986.convert("hello🌍", to: .upper) == "HELLO🌍")
            }

            @Test func `Converting an empty string returns an empty string`() {
                #expect(INCITS_4_1986.convert("", to: .upper).isEmpty)
            }
        }

        @Suite struct `INCITS case conversion integrates with its consumers` {}
    }
}
