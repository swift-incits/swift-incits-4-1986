import Testing

import ASCII
import Byte
import Standard_Library_Extensions
@testable import INCITS_4_1986

@Suite
struct `Case conversion maps ASCII letters to the requested case` {
    @Suite
    struct `String case conversion preserves characters outside ASCII` {
        @Test
        func `String case conversion produces uppercase ASCII letters`() {
            #expect("hello".ascii(case: .upper) == "HELLO")
            #expect("Hello World".ascii(case: .upper) == "HELLO WORLD")
        }

        @Test
        func `String case conversion produces lowercase ASCII letters`() {
            #expect("HELLO".ascii(case: .lower) == "hello")
            #expect("Hello World".ascii(case: .lower) == "hello world")
        }

        @Test
        func `String case conversion preserves non-ASCII`() {
            #expect("hello🌍".ascii(case: .upper) == "HELLO🌍")
            #expect("HELLO🌍".ascii(case: .lower) == "hello🌍")
        }

        @Test
        func `Array case conversion matches String case conversion`() {
            let str = "Hello World"
            let strUpper = str.ascii(case: .upper)

            let codes: [ASCII.Code] = [ASCII.Code].ascii.unchecked(str)
            let bytesUpper = String.ascii.unchecked(
                codes.ascii(case: .upper).map(\.underlying)
            )
            #expect(strUpper == bytesUpper)
        }

        @Test
        func `Case conversion cycles produce the requested final case`() {
            let original = "Hello World"
            let upper = original.ascii(case: .upper)
            let lower = upper.ascii(case: .lower)
            #expect(lower == "hello world")
        }
    }

    @Suite
    struct `Byte case conversion maps letters and preserves other bytes` {
        @Test(arguments: [
            ("a", "A"), ("b", "B"), ("z", "Z"),
            ("m", "M"), ("n", "N"),
        ])
        func `Lowercase bytes convert to uppercase`(lower: Character, upper: Character) {
            let lowerByte = lower.asciiValue!
            let upperByte = upper.asciiValue!
            #expect(ASCII.Code(lowerByte)(case: .upper) == upperByte)
        }

        @Test(arguments: [
            ("A", "a"), ("B", "b"), ("Z", "z"),
            ("M", "m"), ("N", "n"),
        ])
        func `Uppercase bytes convert to lowercase`(upper: Character, lower: Character) {
            let upperByte = upper.asciiValue!
            let lowerByte = lower.asciiValue!
            #expect(ASCII.Code(upperByte)(case: .lower) == lowerByte)
        }

        @Test(arguments: ["0", "1", "9", "!", "@", " "])
        func `Case conversion preserves bytes outside the letter ranges`(char: Character) {
            let byte = char.asciiValue!
            #expect(ASCII.Code(byte)(case: .upper) == byte)
            #expect(ASCII.Code(byte)(case: .lower) == byte)
        }
    }

    @Suite
    struct `Repeated case conversion preserves the first result` {
        @Test
        func `Uppercase is idempotent on strings`() {
            let str = "Hello World 123!"
            let upper1 = str.ascii(case: .upper)
            let upper2 = upper1.ascii(case: .upper)
            #expect(upper1 == upper2, "Applying uppercase twice should be idempotent")
        }

        @Test
        func `Lowercase is idempotent on strings`() {
            let str = "Hello World 123!"
            let lower1 = str.ascii(case: .lower)
            let lower2 = lower1.ascii(case: .lower)
            #expect(lower1 == lower2, "Applying lowercase twice should be idempotent")
        }

        @Test
        func `Uppercase is idempotent on bytes`() {

            let codes = [ASCII.Code](ascii: "Hello World 123!")!
            let upper1 = codes.ascii(case: .upper)
            let upper2 = upper1.ascii(case: .upper)
            #expect(upper1 == upper2, "Applying uppercase twice should be idempotent")
        }

        @Test
        func `Lowercase is idempotent on bytes`() {
            let codes = [ASCII.Code](ascii: "Hello World 123!")!
            let lower1 = codes.ascii(case: .lower)
            let lower2 = lower1.ascii(case: .lower)
            #expect(lower1 == lower2, "Applying lowercase twice should be idempotent")
        }
    }

    @Suite
    struct `ASCII letter cases differ by exactly 32` {
        @Test
        func `Conversion offset is exactly 32`() {
            let lowerA = Character("a").asciiValue!
            let upperA = Character("A").asciiValue!
            #expect(lowerA - upperA == 32)
            #expect(lowerA - upperA == INCITS_4_1986.Case.Conversion.offset)
        }

        @Test(
            arguments: Array(
                zip(
                    ASCII::ASCII.Code.a.underlying...ASCII::ASCII.Code.z.underlying,
                    ASCII::ASCII.Code.A.underlying...ASCII::ASCII.Code.Z.underlying
                )
            )
        )
        func `All letter pairs have correct offset`(lower: UInt8, upper: UInt8) {

            #expect(lower - upper == 32)
        }
    }
}
