// [ASCII.Code]+INCITS_4_1986.ASCII.swift
// swift-incits-4-1986
//
// Namespaced access to INCITS 4-1986 (US-ASCII) constants on [ASCII.Code]

public import ASCII_Primitives_Standard_Library_Integration
import Standard_Library_Extensions

// MARK: - [ASCII.Code] ASCII Namespace

extension [ASCII_Primitives.ASCII.Code] {
    /// Access to ASCII type-level constants and methods
    public static var ascii: ASCII.Type {
        ASCII.self
    }

    /// ASCII static operations namespace for code arrays
    public enum ASCII {}
}

// MARK: - [ASCII.Code] Initializers

extension [ASCII_Primitives.ASCII.Code] {
    /// Creates ASCII code array from a string with validation
    ///
    /// Converts a Swift `String` to an array of ASCII codes, returning `nil` if any character
    /// is outside the ASCII range (U+0000 to U+007F).
    public init?(ascii s: some StringProtocol) {
        guard s.allSatisfy({ $0.isASCII }) else { return nil }
        self = s.utf8.map { ASCII_Primitives.ASCII.Code($0) }
    }

    /// Creates code array from a line ending constant
    public init(ascii lineEnding: INCITS_4_1986.FormatEffectors.Line.Ending) {
        switch lineEnding {
        case .lf: self = [ASCII_Primitives.ASCII.Code.lf]
        case .cr: self = [ASCII_Primitives.ASCII.Code.cr]
        case .crlf: self = [ASCII_Primitives.ASCII.Code].ascii.crlf
        }
    }
}

// MARK: - [ASCII.Code].ASCII Static Methods

extension [ASCII_Primitives.ASCII.Code].ASCII {
    /// Creates ASCII code array from a string without validation
    public static func unchecked(_ s: some StringProtocol) -> [ASCII_Primitives.ASCII.Code] {
        s.utf8.map { ASCII_Primitives.ASCII.Code($0) }
    }

    /// CRLF line ending (0x0D 0x0A)
    ///
    /// The canonical two-code sequence for line endings in Internet protocols.
    /// Consists of CARRIAGE RETURN (0x0D) followed by LINE FEED (0x0A).
    public static var crlf: [ASCII_Primitives.ASCII.Code] {
        [.cr, .lf]
    }

    /// ASCII whitespace codes
    ///
    /// Set containing the four ASCII whitespace characters defined in INCITS 4-1986.
    public static var whitespaces: Set<ASCII_Primitives.ASCII.Code> {
        INCITS_4_1986.whitespaces
    }
}
