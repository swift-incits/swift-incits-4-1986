import ASCII
import Byte
import Standard_Library_Extensions
import Testing

@testable import INCITS_4_1986

@Suite
struct `String operations trim the requested character sets` {
    @Suite
    struct `Strings trim the requested characters from both ends` {
        @Test
        func `Trimming removes leading whitespace`() {
            #expect("  hello".trimming(Set<Character>.ascii.whitespaces) == "hello")
            #expect("\t\nhello".trimming(Set<Character>.ascii.whitespaces) == "hello")
        }

        @Test
        func `Trimming removes trailing whitespace`() {
            #expect("hello  ".trimming(Set<Character>.ascii.whitespaces) == "hello")
            #expect("hello\t\n".trimming(Set<Character>.ascii.whitespaces) == "hello")
        }

        @Test
        func `Trimming removes whitespace from both ends`() {
            #expect("  hello  ".trimming(.ascii.whitespaces) == "hello")

            #expect("\t\nhello\r\n".trimming(where: Set<Character>.ascii.isWhitespace) == "hello")
        }

        @Test
        func `Trimming preserves internal whitespace`() {
            #expect("  hello world  ".trimming(Set<Character>.ascii.whitespaces) == "hello world")
        }

        @Test
        func `Trimming preserves an empty string`() {
            #expect("".trimming(Set<Character>.ascii.whitespaces).isEmpty)
        }

        @Test
        func `All whitespace becomes empty`() {
            #expect("   \t\n\r   ".trimming(Set<Character>.ascii.whitespaces).isEmpty)
        }

        @Test
        func `Trimming removes the requested custom character set`() {
            #expect("***text***".trimming(["*"]) == "text")
            #expect("abcHELLOcba".trimming(["a", "b", "c"]) == "HELLO")
        }
    }

    @Suite
    struct `Substrings trim the requested characters from both ends` {
        @Test
        func `Trimming removes leading and trailing substring whitespace`() {
            let str = "  hello  "
            let sub = str[...]
            #expect(sub.trimming(Set<Character>.ascii.whitespaces) == "hello")
        }
    }
}
