import Testing

import ASCII
import Byte
import Standard_Library_Extensions
@testable import INCITS_4_1986

@Suite
struct `Character sets expose ASCII whitespace operations` {
    @Suite
    struct `Character whitespace sets contain the specified characters` {
        @Test
        func `Whitespace set contains space`() {
            #expect(Set<Character>.ascii.whitespaces.contains(" "))
        }

        @Test
        func `Whitespace set contains tab`() {
            #expect(Set<Character>.ascii.whitespaces.contains("\t"))
        }

        @Test
        func `Whitespace set contains newline`() {
            #expect(Set<Character>.ascii.whitespaces.contains("\n"))
        }

        @Test
        func `Whitespace set contains carriage return`() {
            #expect(Set<Character>.ascii.whitespaces.contains("\r"))
        }

        @Test
        func `Whitespace set has exactly 4 characters`() {
            #expect(INCITS_4_1986.whitespaces.count == 4)
        }

        @Test(arguments: ["a", "Z", "0", "!", "@", "#"])
        func `Whitespace set does not contain non-whitespace`(char: Character) {
            #expect(!Set<Character>.ascii.whitespaces.contains(char))
        }

        @Test
        func `Whitespace set matches expected characters`() {
            let expected: [Character] = [" ", "\t", "\n", "\r"].sorted()
            #expect(INCITS_4_1986.whitespaces.compactMap { Character(ascii: $0.underlying) }.sorted() == expected)
        }

        @Test
        func `All whitespace characters are ASCII`() {
            for char in Set<Character>.ascii.whitespaces {
                #expect(char.isASCII)
            }
        }

        @Test
        func `Whitespace characters match ASCII values`() {
            let whitespaceBytes: Set<UInt8> = [
                ASCII::ASCII.Code.sp.underlying, ASCII::ASCII.Code.htab.underlying, ASCII::ASCII.Code.lf.underlying, ASCII::ASCII.Code.cr.underlying,
            ]
            for char in Set<Character>.ascii.whitespaces {
                if let ascii = char.asciiValue {
                    #expect(whitespaceBytes.contains(ascii))
                }
            }
        }

        @Test
        func `Whitespace sets participate in set operations`() {
            let custom: Set<Character> = [" ", "\t", "x", "y"]
            let intersection = custom.intersection(.ascii.whitespaces)
            #expect(intersection == [" ", "\t"])
        }
    }
}
