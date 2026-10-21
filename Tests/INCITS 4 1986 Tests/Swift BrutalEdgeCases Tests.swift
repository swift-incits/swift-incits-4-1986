import ASCII
import Byte
import Standard_Library_Extensions
import Testing

@testable import INCITS_4_1986

private func isAllASCII(_ bytes: [Byte]) -> Bool {
    bytes.allSatisfy { (try? ASCII.Code($0)) != nil }
}

@Suite
struct `ASCII operations preserve invariants across exhaustive inputs` {
    @Suite
    struct `Every byte obeys classification and case conversion rules` {
        @Test(arguments: Array(UInt8(0)...UInt8(255)))
        func `Every byte has consistent ASCII classification`(byte: UInt8) {

            let isASCII = byte <= 0x7F
            #expect(
                isAllASCII([Byte(bitPattern: byte)]) == isASCII,
                "Byte 0x\(String(byte, radix: 16)) classification inconsistent"
            )

            if ASCII.Code(byte).isControl {

                #expect(
                    !ASCII.Code(byte).isLetter,
                    "Control byte 0x\(String(byte, radix: 16)) cannot be letter"
                )
                #expect(
                    !ASCII.Code(byte).isDigit,
                    "Control byte 0x\(String(byte, radix: 16)) cannot be digit"
                )
            }

            if ASCII.Code(byte).isVisible {
                #expect(
                    ASCII.Code(byte).isPrintable,
                    "Visible byte 0x\(String(byte, radix: 16)) must be printable"
                )
            }
        }

        @Test(arguments: Array(UInt8(0)...UInt8(255)))
        func `Case conversion is idempotent for every byte`(byte: UInt8) {
            let upper = ASCII.Code(byte)(case: .upper)
            let upperAgain = ASCII.Code(upper)(case: .upper)
            #expect(
                upper == upperAgain,
                "Uppercase idempotence failed for 0x\(String(byte, radix: 16))"
            )

            let lower = ASCII.Code(byte)(case: .lower)
            let lowerAgain = ASCII.Code(lower)(case: .lower)
            #expect(
                lower == lowerAgain,
                "Lowercase idempotence failed for 0x\(String(byte, radix: 16))"
            )
        }

        @Test(arguments: Array(UInt8(0)...UInt8(255)))
        func `Case conversion cycles preserve the requested case for every byte`(byte: UInt8) {

            if ASCII.Code(byte).isLetter {
                let cycle = ASCII.Code(ASCII.Code(ASCII.Code(byte)(case: .upper))(case: .lower))(case: .upper)
                #expect(
                    cycle == ASCII.Code(byte)(case: .upper),
                    "Case involution failed for 0x\(String(byte, radix: 16))"
                )
            }
        }
    }

    @Suite
    struct `ASCII predicates agree across the complete character set` {
        @Test(arguments: Array(UInt8(0)...UInt8(127)))
        func `Control and printable are mutually exclusive`(byte: UInt8) {
            let isControl = ASCII.Code(byte).isControl
            let isPrintable = ASCII.Code(byte).isPrintable

            if byte == ASCII::ASCII.Code.sp.underlying {
                #expect(!isControl && isPrintable)
            } else if byte <= 0x1F || byte == 0x7F {
                #expect(
                    isControl && !isPrintable,
                    "0x\(String(byte, radix: 16)) should be control, not printable"
                )
            } else {
                #expect(
                    !isControl && isPrintable,
                    "0x\(String(byte, radix: 16)) should be printable, not control"
                )
            }
        }

        @Test(arguments: Array(UInt8(0)...UInt8(127)))
        func `Every ASCII byte is either control or printable`(byte: UInt8) {
            let isControl = ASCII.Code(byte).isControl
            let isPrintable = ASCII.Code(byte).isPrintable

            #expect(
                isControl != isPrintable,
                "Byte 0x\(String(byte, radix: 16)) must be exactly one of control or printable"
            )
        }

        @Test(arguments: Array(UInt8(0)...UInt8(127)))
        func `Letter implies alphanumeric`(byte: UInt8) {
            if ASCII.Code(byte).isLetter {
                #expect(
                    ASCII.Code(byte).isAlphanumeric,
                    "Letter 0x\(String(byte, radix: 16)) must be alphanumeric"
                )
            }
        }

        @Test(arguments: Array(UInt8(0)...UInt8(127)))
        func `Digit implies alphanumeric`(byte: UInt8) {
            if ASCII.Code(byte).isDigit {
                #expect(
                    ASCII.Code(byte).isAlphanumeric,
                    "Digit 0x\(String(byte, radix: 16)) must be alphanumeric"
                )
            }
        }

        @Test(arguments: Array(UInt8(0)...UInt8(127)))
        func `Uppercase and lowercase are mutually exclusive`(byte: UInt8) {
            let isUpper = ASCII.Code(byte).isUppercase
            let isLower = ASCII.Code(byte).isLowercase

            #expect(
                !(isUpper && isLower),
                "Byte 0x\(String(byte, radix: 16)) cannot be both upper and lower"
            )

            if ASCII.Code(byte).isLetter {
                #expect(
                    isUpper != isLower,
                    "Letter 0x\(String(byte, radix: 16)) must be exactly one of upper or lower"
                )
            } else {
                #expect(
                    !isUpper && !isLower,
                    "Non-letter 0x\(String(byte, radix: 16)) cannot be upper or lower"
                )
            }
        }
    }

    @Suite
    struct `Unicode characters are distinguished from ASCII` {
        @Test
        func `UTF8 sequences containing nonASCII bytes are rejected`() {

            let multiByteSequences: [[Byte]] = [
                [Byte(0xC3), Byte(0xA9)],
                [Byte(0xE2), Byte(0x82), Byte(0xAC)],
                [Byte(0xF0), Byte(0x9F), Byte(0x98), Byte(0x80)],
            ]

            for seq in multiByteSequences {
                #expect(
                    !isAllASCII(seq),
                    "Multi-byte UTF-8 \(seq.map { String($0.bitPattern, radix: 16) }) should fail"
                )
            }
        }

        @Test
        func `Bytes used in UTF16 surrogate encodings are rejected`() {

            let surrogateRangeBytes: [Byte] = [Byte(0xD8), Byte(0xDC), Byte(0xDF), Byte(0xED)]

            for byte in surrogateRangeBytes {
                #expect(
                    !isAllASCII([byte]),
                    "Surrogate-range byte 0x\(String(byte.bitPattern, radix: 16)) should be rejected"
                )
            }
        }

        @Test
        func `Characters resembling ASCII letters are rejected`() {

            let cyrillicA = "а"
            #expect(
                Character(cyrillicA).asciiValue == nil,
                "Cyrillic 'а' should not convert to ASCII"
            )

            let greekA = "Α"
            #expect(Character(greekA).asciiValue == nil, "Greek 'Α' should not convert to ASCII")
        }

        @Test
        func `Zero width characters are rejected`() {
            let zeroWidth = "\u{200B}"
            #expect(
                Character(zeroWidth).asciiValue == nil,
                "Zero-width space should be rejected"
            )
        }

        @Test
        func `Combining characters are rejected`() {

            let combining = "\u{0301}"
            #expect(
                Character(combining).asciiValue == nil,
                "Combining character should be rejected"
            )
        }

        @Test
        func `Unicode whitespace outside ASCII is rejected`() {

            let nbsp = "\u{00A0}"
            #expect(Character(nbsp).asciiValue == nil, "Non-breaking space should be rejected")

            let emSpace = "\u{2003}"
            #expect(Character(emSpace).asciiValue == nil, "Em space should be rejected")
        }
    }

    @Suite
    struct `ASCII validation handles buffers of every size` {
        @Test(arguments: [
            0, 1, 2, 3, 4, 7, 8, 15, 16, 31, 32, 63, 64, 127, 128, 255, 256, 511, 512, 1023, 1024,
        ])
        func `Validation checks buffers at every power of two boundary`(size: Int) {
            let validASCII: [Byte] = Array(repeating: ASCII::ASCII.Code.A.byte, count: size)
            #expect(isAllASCII(validASCII), "Valid ASCII array of size \(size) should pass")

            var invalidASCII = validASCII
            if size > 0 {
                invalidASCII[size - 1] = Byte(0x80)
                #expect(
                    !isAllASCII(invalidASCII),
                    "Invalid ASCII array of size \(size) should fail"
                )
            }
        }

        @Test
        func `Validation accepts one million ASCII bytes`() {
            let massive: [Byte] = Array(repeating: ASCII::ASCII.Code.A.byte, count: 1_000_000)
            #expect(isAllASCII(massive))
        }

        @Test
        func `Validation rejects a nonASCII byte at the end of a million byte buffer`() {
            var massive: [Byte] = Array(repeating: ASCII::ASCII.Code.A.byte, count: 1_000_000)
            massive[999_999] = Byte(0x80)
            #expect(!isAllASCII(massive), "Should detect non-ASCII at end of massive array")
        }

        @Test
        func `Validation rejects alternating valid and invalid bytes`() {
            let size = 1000
            let alternating: [Byte] = (0..<size).map { $0 % 2 == 0 ? ASCII::ASCII.Code.A.byte : Byte(bitPattern: 0x80) }
            #expect(!isAllASCII(alternating), "Alternating pattern should fail")
        }
    }

    @Suite
    struct `Normalization handles consecutive and incomplete line endings` {
        @Test
        func `Normalization handles every line ending combination`() {
            let pathological = "\r\n\r\r\n\n\r\n\n\n\r\r\r\n\r\n"

            let asLF = pathological.normalized(to: .lf)
            #expect(!asLF.contains("\r"), "All CR should be converted")

            let asCRLF = pathological.normalized(to: .crlf)

            #expect(asCRLF.contains("\r\n"), "Should contain CRLF")
        }

        @Test
        func `Normalization handles a standalone CR at every position`() {
            let positions = ["start\rmiddle", "middle\rend", "\rlone", "double\r\rCR"]
            for text in positions {
                let normalized = text.normalized(to: .lf)
                #expect(!normalized.contains("\r"), "Lone CR should be normalized in '\(text)'")
            }
        }

        @Test
        func `Normalization converts consecutive CRLF pairs`() {
            let text = "line1\r\n\r\nline2"
            let asLF = text.normalized(to: .lf)
            #expect(asLF == "line1\n\nline2", "Consecutive CRLF should become consecutive LF")
        }

        @Test
        func `Normalization handles text containing only line endings`() {
            let onlyEndings = "\r\n\r\n\r\n"
            let asLF = onlyEndings.normalized(to: .lf)
            #expect(asLF == "\n\n\n", "Should normalize to LF only")
        }

        @Test
        func `Normalization converts a final CR without a following LF`() {
            let incomplete = "text\r"
            let asLF = incomplete.normalized(to: .lf)
            #expect(asLF == "text\n", "Trailing CR should normalize to LF")
        }

        @Test
        func `Normalization preserves surrounding ASCII characters`() {
            var text = ""
            for _ in 0..<100 {
                text += "x\rx\nx\r\n"
            }
            let normalized = text.normalized(to: .lf)
            #expect(!normalized.contains("\r"), "All line endings should normalize")
        }

        @Test
        func `Repeated normalization preserves normalized text`() {
            var text = "line1\nline2\nline3"

            for _ in 0..<100 {
                text = text.normalized(to: .lf)
            }
            #expect(text == "line1\nline2\nline3", "Repeated normalization should be stable")
        }
    }

    @Suite
    struct `Trimming preserves content across long and alternating inputs` {
        @Test
        func `Trimming removes ten thousand leading spaces`() {
            let massive = String(repeating: " ", count: 10000) + "content"
            let trimmed = massive.trimming(.ascii.whitespaces)
            #expect(trimmed == "content", "Should trim 10K leading spaces")
        }

        @Test
        func `Trimming removes ten thousand trailing spaces`() {
            let massive = "content" + String(repeating: " ", count: 10000)
            let trimmed = massive.trimming(.ascii.whitespaces)
            #expect(trimmed == "content", "Should trim 10K trailing spaces")
        }

        @Test
        func `Trimming preserves alternating internal whitespace and content`() {
            let alternating = " x " + String(repeating: " x ", count: 1000)
            let trimmed = alternating.trimming(.ascii.whitespaces)
            #expect(trimmed.hasPrefix("x"), "Should trim leading")
            #expect(trimmed.hasSuffix("x"), "Should trim trailing")
            #expect(trimmed.contains(" x "), "Should preserve internal")
        }

        @Test
        func `Trimming removes mixed leading and trailing ASCII whitespace`() {
            let mixed = " \t\n\r content \r\n\t "
            let trimmed = mixed.trimming(.ascii.whitespaces)
            #expect(trimmed == "content", "Should trim all whitespace types")
        }

        @Test
        func `Trimming with an empty set preserves the string`() {
            let text = "   content   "
            let untrimmed = text.trimming(Set<Character>())
            #expect(untrimmed == text, "Empty set should not trim")
        }

        @Test
        func `Trimming removes a string containing only characters in the set`() {
            let text = "aaaaaaa"
            let trimmed = text.trimming(Set(["a"]))
            #expect(trimmed.isEmpty, "Should trim to empty when all match")
        }

        @Test
        func `Trimming handles strings containing one character`() {
            #expect(" ".trimming(.ascii.whitespaces).isEmpty)
            #expect("x".trimming(.ascii.whitespaces) == "x")
        }
    }

    @Suite
    struct `Case conversion remains stable across repeated operations` {
        @Test
        func `Case conversion preserves every byte outside the letter ranges`() {

            let nonLetters = Array(UInt8(0)...UInt8(127)).filter { !ASCII.Code($0).isLetter }
            for byte in nonLetters {
                #expect(
                    ASCII.Code(byte)(case: .upper) == byte,
                    "Non-letter 0x\(String(byte, radix: 16)) should be unchanged by uppercase"
                )
                #expect(
                    ASCII.Code(byte)(case: .lower) == byte,
                    "Non-letter 0x\(String(byte, radix: 16)) should be unchanged by lowercase"
                )
            }
        }

        @Test
        func `Case conversion cycles preserve every ASCII letter`() {

            for byte in ASCII::ASCII.Code.A.underlying...ASCII::ASCII.Code.Z.underlying {
                let lower = ASCII.Code(byte)(case: .lower)
                let backToUpper = ASCII.Code(lower)(case: .upper)
                #expect(backToUpper == byte, "Round-trip failed for 0x\(String(byte, radix: 16))")
            }

            for byte in ASCII::ASCII.Code.a.underlying...ASCII::ASCII.Code.z.underlying {
                let upper = ASCII.Code(byte)(case: .upper)
                let backToLower = ASCII.Code(upper)(case: .lower)
                #expect(backToLower == byte, "Round-trip failed for 0x\(String(byte, radix: 16))")
            }
        }

        @Test
        func `String case conversion preserves length`() {
            let test = "Hello World 123 !@#"
            #expect(test.ascii(case: .upper).count == test.count)
            #expect(test.ascii(case: .lower).count == test.count)
        }

        @Test
        func `Array case conversion preserves length`() {

            let codes: [ASCII.Code] = [.H, .e, .l, .l, .o]
            #expect(codes.ascii(case: .upper).count == codes.count)
            #expect(codes.ascii(case: .lower).count == codes.count)
        }

        @Test
        func `Case conversion remains stable after one thousand repetitions`() {
            var codes: [ASCII.Code] = [.H, .e, .l, .l, .o]

            for _ in 0..<1000 {
                codes = codes.ascii(case: .upper)
            }
            #expect(codes == [.H, .E, .L, .L, .O])

            for _ in 0..<1000 {
                codes = codes.ascii(case: .lower)
            }
            #expect(codes == [.h, .e, .l, .l, .o])
        }
    }

    @Suite
    struct `Validation checks every byte and buffer position` {
        @Test
        func `Validation accepts an array containing every ASCII byte`() {
            let allValidASCII: [Byte] = (UInt8(0)...UInt8(127)).map(Byte.init(bitPattern:))
            #expect(isAllASCII(allValidASCII), "All 128 ASCII bytes should validate")
        }

        @Test
        func `Validation rejects every nonASCII byte individually`() {
            for value in UInt8(128)...UInt8(255) {
                let byte = Byte(bitPattern: value)
                #expect(!isAllASCII([byte]), "Byte 0x\(String(value, radix: 16)) should fail")
            }
        }

        @Test
        func `Validation rejects a nonASCII byte at every array position`() {
            let size = 100
            for position in 0..<size {
                var bytes: [Byte] = Array(repeating: ASCII::ASCII.Code.A.byte, count: size)
                bytes[position] = Byte(0x80)
                #expect(!isAllASCII(bytes), "Should detect non-ASCII at position \(position)")
            }
        }

        @Test
        func `Validation checks every possible first byte`() {
            for firstByte in UInt8(0)...UInt8(255) {
                let array: [Byte] = [Byte(bitPattern: firstByte), ASCII::ASCII.Code.A.byte, ASCII::ASCII.Code.B.byte]
                let expected = firstByte <= 0x7F
                #expect(
                    isAllASCII(array) == expected,
                    "First byte 0x\(String(firstByte, radix: 16)) validation incorrect"
                )
            }
        }

        @Test
        func `Validation checks every possible last byte`() {
            for lastByte in UInt8(0)...UInt8(255) {
                let array: [Byte] = [ASCII::ASCII.Code.A.byte, ASCII::ASCII.Code.B.byte, Byte(bitPattern: lastByte)]
                let expected = lastByte <= 0x7F
                #expect(
                    isAllASCII(array) == expected,
                    "Last byte 0x\(String(lastByte, radix: 16)) validation incorrect"
                )
            }
        }
    }

    @Suite
    struct `String conversion preserves all valid ASCII bytes` {
        @Test
        func `Every ASCII character survives conversion to a string and back`() {

            for value in UInt8(0)...UInt8(127) {
                let byte = Byte(bitPattern: value)
                if let str = String(ascii: [byte]) {
                    if let backToCodes = [ASCII.Code](ascii: str) {
                        #expect(
                            backToCodes.map(\.underlying) == [value],
                            "Round-trip failed for 0x\(String(value, radix: 16))"
                        )
                    }
                }
            }
        }

        @Test
        func `String conversion fails for non-ASCII`() {
            for value in UInt8(128)...UInt8(255) {
                let byte = Byte(bitPattern: value)
                #expect(
                    String(ascii: [byte]) == nil,
                    "Non-ASCII byte 0x\(String(value, radix: 16)) should fail conversion"
                )
            }
        }

        @Test
        func `Empty array converts to empty string`() {
            let empty: [Byte] = []
            #expect(String(ascii: empty)?.isEmpty == true)
        }

        @Test
        func `Empty string converts to empty array`() {
            let empty = ""
            #expect([ASCII.Code](ascii: empty) == [])
        }

        @Test
        func `String conversion preserves embedded NUL bytes`() {
            let codes: [ASCII.Code] = [.A, .nul, .B]
            if let str = String(ascii: codes.map(\.byte)) {

                #expect(str.count == 3, "NUL should be preserved in string")
            }
        }

        @Test
        func `All control characters convert and round-trip`() {

            let nulUInt = ASCII::ASCII.Code.nul.underlying
            let usUInt = ASCII::ASCII.Code.us.underlying
            let controls: [Byte] = (nulUInt...usUInt).map(Byte.init(bitPattern:)) + [ASCII::ASCII.Code.del.byte]

            if let str = String(ascii: controls) {
                if let backToCodes = [ASCII.Code](ascii: str) {
                    #expect(
                        backToCodes.map(\.byte) == controls,
                        "Control characters should round-trip"
                    )
                } else {
                    Issue.record("Control characters failed to convert back to codes")
                }
            } else {
                Issue.record("Control characters failed to convert to string")
            }
        }
    }
}
