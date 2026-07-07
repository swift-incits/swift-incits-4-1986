// INCITS_4_1986.ASCII.swift
// swift-incits-4-1986
//
// Generic ASCII operations wrapper for bytes and strings

public import ASCII_Primitives_Standard_Library_Integration
import Standard_Library_Extensions

// Note: `ASCII.Code` is shadowed by the wrapper `INCITS_4_1986.ASCII<Source>`
// in same-module name resolution. All references in this file are fully
// qualified as `ASCII_Primitives.ASCII.Code`.

extension INCITS_4_1986 {
    /// Generic ASCII operations wrapper
    ///
    /// Provides ASCII-related operations for byte collections and strings per INCITS 4-1986 (US-ASCII).
    /// This generic wrapper avoids intermediate allocations when working with slices.
    ///
    /// ## Overview
    ///
    /// The `ASCII` struct wraps any source type and provides ASCII operations via conditional conformances:
    /// - For `Collection<UInt8>`: byte-level validation, case conversion, classification
    /// - For `StringProtocol`: string-level validation and case conversion
    ///
    /// ## Performance
    ///
    /// Methods are marked `@inlinable` for optimal performance. The generic design means
    /// no intermediate allocation is needed when working with slices:
    ///
    /// ```swift
    /// let slice = bytes[start..<end]
    /// let lower = slice.ascii.lowercased()  // No intermediate Array copy!
    ///
    /// let substring = string[start..<end]
    /// let upper = substring.ascii.uppercased()  // No intermediate String copy!
    /// ```
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986``
    public struct ASCII<Source> {
        /// The wrapped source (bytes or string)
        public let source: Source

        /// Creates an ASCII wrapper for the given source
        @inlinable
        public init(_ source: Source) {
            self.source = source
        }
    }
}

// MARK: - Code Collection: Validation

extension INCITS_4_1986.ASCII where Source: Collection, Source.Element == ASCII_Primitives.ASCII.Code {
    /// The wrapped code collection (alias for source)
    @inlinable
    public var bytes: Source { source }

    /// Returns true if all codes are valid ASCII (0x00-0x7F)
    ///
    /// Trivially true: every `ASCII.Code` is by construction in 0x00-0x7F.
    /// Kept for parity with the `StringProtocol` and `UInt8` overloads.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// [ASCII.Code.h, .e, .l, .l, .o].ascii.isAllASCII  // true
    /// ```
    @inlinable
    public var isAllASCII: Bool {
        true
    }

    /// Returns the codes as an array (trivially valid).
    ///
    /// Provided for parity with the `StringProtocol` overload.
    @inlinable
    public func callAsFunction() -> [ASCII_Primitives.ASCII.Code]? {
        Array(source)
    }
}

// MARK: - Code Collection: Case Conversion

extension INCITS_4_1986.ASCII where Source: Collection, Source.Element == ASCII_Primitives.ASCII.Code {
    /// Converts ASCII letters to specified case
    ///
    /// Enables call syntax: `codes.ascii(case: .upper)`
    ///
    /// - Parameter case: Target case (`.upper` or `.lower`)
    /// - Returns: New code array with ASCII letters converted
    @inlinable
    public func callAsFunction(case: INCITS_4_1986.Case) -> [ASCII_Primitives.ASCII.Code] {
        INCITS_4_1986.convert(source, to: `case`)
    }

    /// Converts ASCII letters to uppercase
    ///
    /// Transforms all ASCII letters (a-z) to uppercase (A-Z),
    /// leaving all other codes unchanged.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let hello: [ASCII.Code] = [.h, .e, .l, .l, .o]
    /// let upper = hello.ascii.uppercased()  // [.H, .E, .L, .L, .O]
    ///
    /// // Works efficiently with slices - no intermediate copy
    /// let slice = codes[start..<end]
    /// let upperSlice = slice.ascii.uppercased()
    /// ```
    ///
    /// - Returns: New code array with ASCII letters converted to uppercase
    @inlinable
    public func uppercased() -> [ASCII_Primitives.ASCII.Code] {
        INCITS_4_1986.convert(source, to: .upper)
    }

    /// Converts ASCII letters to lowercase
    ///
    /// Transforms all ASCII letters (A-Z) to lowercase (a-z),
    /// leaving all other codes unchanged.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let hello: [ASCII.Code] = [.H, .E, .L, .L, .O]
    /// let lower = hello.ascii.lowercased()  // [.h, .e, .l, .l, .o]
    ///
    /// // Avoid String allocation for case-insensitive keys
    /// let key = String(decoding: keyCodes.ascii.lowercased().map(\.underlying), as: UTF8.self)
    /// ```
    ///
    /// - Returns: New code array with ASCII letters converted to lowercase
    @inlinable
    public func lowercased() -> [ASCII_Primitives.ASCII.Code] {
        INCITS_4_1986.convert(source, to: .lower)
    }
}

extension INCITS_4_1986.ASCII where Source: Collection, Source.Element == ASCII_Primitives.ASCII.Code {
    /// Trims ASCII codes from both ends of the collection
    ///
    /// Removes leading and trailing codes that match the given character set.
    /// Returns a zero-copy SubSequence view of the original collection.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let codes: [ASCII.Code] = [.sp, .H, .i, .sp]  // " Hi "
    /// let trimmed = codes.ascii.trimming([.sp])  // [.H, .i] ("Hi")
    ///
    /// // Trim LWSP (linear whitespace per RFC 822)
    /// let whitespace: Set<ASCII.Code> = [.sp, .htab]  // SPACE, HTAB
    /// let header = headerCodes.ascii.trimming(whitespace)
    /// ```
    ///
    /// - Parameter characterSet: The set of ASCII codes to trim
    /// - Returns: A subsequence with the specified codes trimmed from both ends
    @inlinable
    public func trimming(_ characterSet: Set<ASCII_Primitives.ASCII.Code>) -> Source.SubSequence {
        source.trimming(characterSet)
    }
}

// MARK: - Code Collection: Comparison

extension INCITS_4_1986.ASCII where Source: Collection, Source.Element == ASCII_Primitives.ASCII.Code {
    /// Compares two code sequences for ASCII case-insensitive equality
    ///
    /// Performs element-wise comparison using ASCII case-insensitive rules.
    /// Only ASCII letters (A-Z, a-z) are compared case-insensitively;
    /// all other codes must match exactly.
    ///
    /// ## Performance
    ///
    /// This method is O(n) and performs **zero allocations**. Unlike `lowercased() == other`,
    /// this compares codes directly without creating intermediate arrays.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let header = "Content-Type".utf8.map(ASCII.Code.init)
    /// let lower = "content-type".utf8.map(ASCII.Code.init)
    ///
    /// header.ascii.elementsEqualCaseInsensitive(lower)  // true
    /// ```
    ///
    /// - Parameter other: The code sequence to compare against
    /// - Returns: `true` if sequences are equal ignoring ASCII case, `false` otherwise
    @inlinable
    public func elementsEqualCaseInsensitive<Other: Collection>(
        _ other: Other
    ) -> Bool where Other.Element == ASCII_Primitives.ASCII.Code {
        guard source.count == other.count else { return false }

        var sourceIterator = source.makeIterator()
        var otherIterator = other.makeIterator()

        while let s = sourceIterator.next(), let o = otherIterator.next() {
            // Use single-code lowercased() - no allocation
            guard
                INCITS_4_1986.Case.Conversion.convert(s, to: .lower)
                    == INCITS_4_1986.Case.Conversion.convert(o, to: .lower)
            else {
                return false
            }
        }

        return true
    }

    /// Checks if collection starts with prefix using ASCII case-insensitive comparison
    ///
    /// ## Example
    ///
    /// ```swift
    /// let header = "Content-Type: text/plain".utf8.map(ASCII.Code.init)
    /// header.ascii.hasPrefix(caseInsensitive: "content-type".utf8.map(ASCII.Code.init))  // true
    /// ```
    ///
    /// - Parameter prefix: The prefix to check for
    /// - Returns: `true` if collection starts with prefix (case-insensitive)
    @inlinable
    public func hasPrefix<Prefix: Collection>(
        caseInsensitive prefix: Prefix
    ) -> Bool where Prefix.Element == ASCII_Primitives.ASCII.Code {
        guard source.count >= prefix.count else { return false }

        var sourceIndex = source.startIndex
        for prefixCode in prefix {
            guard
                INCITS_4_1986.Case.Conversion.convert(source[sourceIndex], to: .lower)
                    == INCITS_4_1986.Case.Conversion.convert(prefixCode, to: .lower)
            else {
                return false
            }
            sourceIndex = source.index(after: sourceIndex)
        }

        return true
    }
}

// MARK: - Code Collection: Line Operations

extension INCITS_4_1986.ASCII where Source: Collection, Source.Element == ASCII_Primitives.ASCII.Code {
    /// A range representing a line within a code collection
    ///
    /// Contains the start and end indices of a line, excluding the line ending.
    public typealias LineRange = Range<Source.Index>

    /// Returns index ranges for all lines in the code collection (zero-copy)
    ///
    /// Splits the collection at ASCII line endings (CRLF, CR, or LF) and returns
    /// the index ranges of each line. This enables zero-copy access to lines
    /// by using slices rather than copying codes.
    ///
    /// ## Performance
    ///
    /// This method is O(n) and performs **minimal allocations** - only the array
    /// of ranges is allocated, not the line contents themselves. Access lines
    /// via `source[range]` to get zero-copy slices.
    ///
    /// ## Line Ending Handling
    ///
    /// Recognizes all ASCII line endings per INCITS 4-1986:
    /// - CRLF (0x0D 0x0A) - Windows/Internet style
    /// - LF (0x0A) - Unix style
    /// - CR (0x0D) - Classic Mac style
    ///
    /// ## Example
    ///
    /// ```swift
    /// let text = "Hello\r\nWorld\nFoo".utf8.map(ASCII.Code.init)
    /// let ranges = text.ascii.lineRanges()
    ///
    /// for range in ranges {
    ///     let line = text[range]  // Zero-copy slice!
    ///     print(String(decoding: line.map(\.underlying), as: UTF8.self))
    /// }
    /// // Prints: "Hello", "World", "Foo"
    /// ```
    ///
    /// - Parameter estimatedLineCount: Optional hint for number of lines to reserve capacity
    /// - Returns: Array of index ranges, one per line (excluding line endings)
    @inlinable
    public func lineRanges(estimatedLineCount: Int? = nil) -> [LineRange] {
        var ranges: [LineRange] = []
        if let estimate = estimatedLineCount {
            ranges.reserveCapacity(estimate)
        }

        var lineStart = source.startIndex
        var index = source.startIndex

        while index < source.endIndex {
            let code = source[index]

            if code == ASCII_Primitives.ASCII.Code.cr {
                // End current line (excluding CR)
                ranges.append(lineStart..<index)

                // Check for CRLF
                let next = source.index(after: index)
                if next < source.endIndex && source[next] == ASCII_Primitives.ASCII.Code.lf {
                    // CRLF - skip both
                    index = source.index(after: next)
                } else {
                    // Just CR
                    index = next
                }
                lineStart = index
            } else if code == ASCII_Primitives.ASCII.Code.lf {
                // End current line (excluding LF)
                ranges.append(lineStart..<index)
                index = source.index(after: index)
                lineStart = index
            } else {
                index = source.index(after: index)
            }
        }

        // Add final line if there's content after the last line ending
        if lineStart < source.endIndex {
            ranges.append(lineStart..<source.endIndex)
        }

        return ranges
    }

    /// Splits the code collection into lines (allocating copies)
    ///
    /// Convenience method that returns actual code arrays for each line.
    /// Use `lineRanges()` if you need zero-copy access.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let text = "Hello\r\nWorld".utf8.map(ASCII.Code.init)
    /// let lines = text.ascii.lines()  // [[ASCII.Code], [ASCII.Code]]
    /// ```
    ///
    /// - Returns: Array of code arrays, one per line
    @inlinable
    public func lines() -> [[ASCII_Primitives.ASCII.Code]] {
        lineRanges().map { Array(source[$0]) }
    }
}

// MARK: - Code Collection: Predicates

extension INCITS_4_1986.ASCII where Source: Collection, Source.Element == ASCII_Primitives.ASCII.Code {
    /// Returns true if all codes are ASCII whitespace characters
    ///
    /// Tests whether every code is one of: SPACE (0x20), TAB (0x09), LF (0x0A), CR (0x0D).
    @inlinable
    public var isAllWhitespace: Bool {
        ASCII.Classification.isAllWhitespace(source)
    }

    /// Returns true if all codes are ASCII digits (0-9)
    @inlinable
    public var isAllDigits: Bool {
        ASCII.Classification.isAllDigits(source)
    }

    /// Returns true if all codes are ASCII letters (A-Z, a-z)
    @inlinable
    public var isAllLetters: Bool {
        ASCII.Classification.isAllLetters(source)
    }

    /// Returns true if all codes are ASCII alphanumeric (A-Z, a-z, 0-9)
    @inlinable
    public var isAllAlphanumeric: Bool {
        ASCII.Classification.isAllAlphanumeric(source)
    }

    /// Returns true if all codes are ASCII control characters (0x00-0x1F or 0x7F)
    @inlinable
    public var isAllControl: Bool {
        ASCII.Classification.isAllControl(source)
    }

    /// Returns true if all codes are ASCII visible characters (0x21-0x7E)
    @inlinable
    public var isAllVisible: Bool {
        ASCII.Classification.isAllVisible(source)
    }

    /// Returns true if all codes are ASCII printable characters (0x20-0x7E)
    @inlinable
    public var isAllPrintable: Bool {
        ASCII.Classification.isAllPrintable(source)
    }

    /// Returns true if all ASCII letters are lowercase (non-letters ignored)
    @inlinable
    public var isAllLowercase: Bool {
        ASCII.Classification.isAllLowercase(source)
    }

    /// Returns true if all ASCII letters are uppercase (non-letters ignored)
    @inlinable
    public var isAllUppercase: Bool {
        ASCII.Classification.isAllUppercase(source)
    }

    /// Returns true if collection contains any non-ASCII codes (>= 0x80)
    ///
    /// Always returns false: every `ASCII.Code` is by construction < 0x80.
    /// Kept for parity with the `StringProtocol` and `UInt8` overloads.
    @inlinable
    public var containsNonASCII: Bool {
        false
    }

    /// Returns true if collection contains at least one hex digit (0-9, A-F, a-f)
    @inlinable
    public var containsHexDigit: Bool {
        ASCII.Classification.containsHexDigit(source)
    }
}

// MARK: - StringProtocol: Validation

extension INCITS_4_1986.ASCII where Source: StringProtocol {
    /// The wrapped string (alias for source)
    @inlinable
    public var value: Source { source }

    /// Returns true if all characters are valid ASCII
    ///
    /// ## Usage
    ///
    /// ```swift
    /// "hello".ascii.isAllASCII  // true
    /// "hello🌍".ascii.isAllASCII  // false
    /// ```
    @inlinable
    public var isAllASCII: Bool {
        INCITS_4_1986.Text.Classification.isAllASCII(source)
    }

    /// Returns the string if all characters are ASCII, nil otherwise
    ///
    /// ```swift
    /// "Hello".ascii()  // Optional("Hello")
    /// "Hello🌍".ascii()  // nil
    /// ```
    @inlinable
    public func callAsFunction() -> Source? {
        isAllASCII ? source : nil
    }
}

// MARK: - StringProtocol: Case Conversion

extension INCITS_4_1986.ASCII where Source: StringProtocol {
    /// Converts ASCII letters to specified case
    ///
    /// Transforms all ASCII letters (A-Z, a-z) to the specified case, leaving
    /// all other characters unchanged. This is a **Unicode-safe** operation: non-ASCII characters
    /// (including emoji and accented letters) are preserved exactly as-is.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// "Hello World".ascii(case: .upper)  // "HELLO WORLD"
    /// "hello🌍".ascii(case: .upper)      // "HELLO🌍"
    /// ```
    ///
    /// - Parameter case: The target case (`.upper` or `.lower`)
    /// - Returns: New string with ASCII letters converted to the specified case
    @inlinable
    public func callAsFunction(case: INCITS_4_1986.Case) -> Source {
        INCITS_4_1986.convert(source, to: `case`)
    }

    /// Converts ASCII letters to uppercase
    ///
    /// Convenience method for `ascii(case: .upper)`.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// "hello".ascii.uppercased()  // "HELLO"
    /// "hello🌍".ascii.uppercased()  // "HELLO🌍"
    /// ```
    @inlinable
    public func uppercased() -> Source {
        INCITS_4_1986.convert(source, to: .upper)
    }

    /// Converts ASCII letters to lowercase
    ///
    /// Convenience method for `ascii(case: .lower)`.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// "HELLO".ascii.lowercased()  // "hello"
    /// "HELLO🌍".ascii.lowercased()  // "hello🌍"
    /// ```
    @inlinable
    public func lowercased() -> Source {
        INCITS_4_1986.convert(source, to: .lower)
    }

    /// Detects the line ending style used in the string
    ///
    /// Returns the first line ending type found, or `nil` if no line endings are present.
    /// Prioritizes CRLF detection since it contains both CR and LF.
    ///
    /// ## See Also
    ///
    /// - ``INCITS_4_1986/LineEnding/Detection/detect(_:)``
    @inlinable
    public func detectedLineEnding() -> INCITS_4_1986.FormatEffectors.Line.Ending? {
        INCITS_4_1986.LineEnding.Detection.detect(source)
    }
}

// MARK: - StringProtocol: Predicates

extension INCITS_4_1986.ASCII where Source: StringProtocol {
    /// Returns true if all characters are ASCII whitespace
    @inlinable
    public var isAllWhitespace: Bool {
        ASCII.Classification.isAllWhitespace(source.utf8)
    }

    /// Returns true if all characters are ASCII digits (0-9)
    @inlinable
    public var isAllDigits: Bool {
        ASCII.Classification.isAllDigits(source.utf8)
    }

    /// Returns true if all characters are ASCII letters (A-Z, a-z)
    @inlinable
    public var isAllLetters: Bool {
        ASCII.Classification.isAllLetters(source.utf8)
    }

    /// Returns true if all characters are ASCII alphanumeric (A-Z, a-z, 0-9)
    @inlinable
    public var isAllAlphanumeric: Bool {
        ASCII.Classification.isAllAlphanumeric(source.utf8)
    }

    /// Returns true if all characters are ASCII control characters (0x00-0x1F or 0x7F)
    @inlinable
    public var isAllControl: Bool {
        ASCII.Classification.isAllControl(source.utf8)
    }

    /// Returns true if all characters are ASCII visible characters (0x21-0x7E)
    @inlinable
    public var isAllVisible: Bool {
        ASCII.Classification.isAllVisible(source.utf8)
    }

    /// Returns true if all characters are ASCII printable characters (0x20-0x7E)
    @inlinable
    public var isAllPrintable: Bool {
        ASCII.Classification.isAllPrintable(source.utf8)
    }

    /// Returns true if all ASCII letters are lowercase (non-letters ignored)
    @inlinable
    public var isAllLowercase: Bool {
        ASCII.Classification.isAllLowercase(source.utf8)
    }

    /// Returns true if all ASCII letters are uppercase (non-letters ignored)
    @inlinable
    public var isAllUppercase: Bool {
        ASCII.Classification.isAllUppercase(source.utf8)
    }

    /// Returns true if string contains any non-ASCII characters (>= 0x80)
    @inlinable
    public var containsNonASCII: Bool {
        ASCII.Classification.containsNonASCII(source.utf8)
    }

    /// Returns true if string contains at least one hex digit (0-9, A-F, a-f)
    @inlinable
    public var containsHexDigit: Bool {
        ASCII.Classification.containsHexDigit(source.utf8)
    }

    /// Returns true if string contains mixed line ending styles
    @inlinable
    public var containsMixedLineEndings: Bool {
        INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings(source)
    }
}

// MARK: - StringProtocol: Static Constants

extension INCITS_4_1986.ASCII where Source: StringProtocol {
    /// Line Feed character as a string
    public static var lf: Source {
        Source(decoding: [INCITS_4_1986.Character.Control.lf], as: UTF8.self)
    }

    /// Carriage Return character as a string
    public static var cr: Source {
        Source(decoding: [INCITS_4_1986.Character.Control.cr], as: UTF8.self)
    }

    /// CRLF sequence as a string
    public static var crlf: Source {
        Source(decoding: INCITS_4_1986.Character.Control.crlf, as: UTF8.self)
    }
}

// MARK: - StringProtocol: Static Methods

extension INCITS_4_1986.ASCII where Source: StringProtocol {
    /// Creates a string from bytes without ASCII validation
    ///
    /// Constructs a String from a byte array, assuming all bytes are valid ASCII without validation.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let bytes: [UInt8] = [104, 101, 108, 108, 111]
    /// let text = String.ascii.unchecked(bytes)  // "hello"
    /// ```
    ///
    /// - Parameter bytes: Array of bytes to decode as ASCII (assumed valid, no checking performed)
    /// - Returns: String decoded from the bytes
    public static func unchecked(_ bytes: [UInt8]) -> Source {
        Source(decoding: bytes, as: UTF8.self)
    }
}
