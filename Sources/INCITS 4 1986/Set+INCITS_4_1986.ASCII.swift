// Set+INCITS_4_1986.ASCII.swift
// swift-incits-4-1986
//
// INCITS 4-1986: ASCII character sets on Set types

import Standard_Library_Extensions
import Binary_Primitives

// MARK: - Set.ASCII Namespace

extension Set {
    /// Convenient access to INCITS 4-1986 (US-ASCII) character constants
    public static var ascii: ASCII.Type {
        ASCII.self
    }

    public enum ASCII {}
}

// MARK: - Set<Character>.ASCII

extension Set<Character>.ASCII {
    /// ASCII whitespace characters as Set<Character>
    ///
    /// Derived from the canonical byte-level definition in `INCITS_4_1986.whitespaces`.
    /// Per INCITS 4-1986, these are the only four whitespace characters in US-ASCII:
    /// - U+0020 (SPACE)
    /// - U+0009 (HORIZONTAL TAB)
    /// - U+000A (LINE FEED)
    /// - U+000D (CARRIAGE RETURN)
    ///
    /// This is explicitly ASCII-only and does not include Unicode whitespace
    /// characters (e.g., U+00A0 NO-BREAK SPACE, U+2003 EM SPACE).
    ///
    /// - Note: For trimming operations that must handle CRLF sequences (which Swift
    ///   treats as a single grapheme cluster), use ``isWhitespace(_:)`` predicate instead.
    public static let whitespaces: Set<Character> = {
        var set = Set(
            INCITS_4_1986.whitespaces.map {
                Character(UnicodeScalar($0.underlying))
            })
        set.insert(Character("\r\n"))
        return set
    }()

    /// Tests if a Character is ASCII whitespace (handles grapheme clusters)
    ///
    /// Returns `true` if ALL Unicode scalars in the Character are ASCII whitespace codes.
    /// This correctly handles Swift's grapheme clustering where `\r\n` (CRLF) is a single Character.
    ///
    /// Per INCITS 4-1986, ASCII whitespace codes are: SP (0x20), HT (0x09), LF (0x0A), CR (0x0D).
    public static func isWhitespace(_ char: Character) -> Bool {
        char.unicodeScalars.allSatisfy { scalar in
            scalar.value < 128 && INCITS_4_1986.whitespaces.contains(ASCII_Primitives.ASCII.Code(UInt8(scalar.value)))
        }
    }
}

// MARK: - Set<ASCII.Code>

extension Set where Element == ASCII_Primitives.ASCII.Code {
    /// ASCII whitespace characters as Set<ASCII.Code>
    ///
    /// Derived from the canonical typed definition in `INCITS_4_1986.whitespaces`.
    /// Per INCITS 4-1986, these are the only four whitespace characters in US-ASCII:
    /// - U+0020 (SPACE)
    /// - U+0009 (HORIZONTAL TAB)
    /// - U+000A (LINE FEED)
    /// - U+000D (CARRIAGE RETURN)
    ///
    /// The `Element == ASCII.Code` constraint already encodes the ASCII domain,
    /// so no nested `.ASCII` namespace is required (contrast `Set<Character>.ASCII`).
    public static var whitespaces: Set<ASCII_Primitives.ASCII.Code> { INCITS_4_1986.whitespaces }
}
