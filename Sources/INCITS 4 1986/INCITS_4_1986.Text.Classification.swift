import Standard_Library_Extensions

extension INCITS_4_1986.Text {

    public enum Classification {}
}

extension INCITS_4_1986.Text.Classification {

    @inlinable
    public static func isAllASCII<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { $0 <= 0x7F }
    }

    @inlinable
    public static func containsNonASCII<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.contains { $0 > 0x7F }
    }

    @inlinable
    public static func isAllWhitespace<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isWhitespace(byte)
        }
    }

    @inlinable
    public static func isAllDigits<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isDigit(byte)
        }
    }

    @inlinable
    public static func isAllLetters<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isLetter(byte)
        }
    }

    @inlinable
    public static func isAllAlphanumeric<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isAlphanumeric(byte)
        }
    }

    @inlinable
    public static func isAllControl<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isControl(byte)
        }
    }

    @inlinable
    public static func isAllVisible<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isVisible(byte)
        }
    }

    @inlinable
    public static func isAllPrintable<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in
            INCITS_4_1986.Classification.isPrintable(byte)
        }
    }

    @inlinable
    public static func containsHexDigit<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.contains { byte in
            INCITS_4_1986.Classification.isHexDigit(byte)
        }
    }

    @inlinable
    public static func isAllLowercase<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in

            guard byte < 0x80 else { return true }
            return INCITS_4_1986.Classification.isLetter(byte)
                ? INCITS_4_1986.Classification.isLowercase(byte)
                : true
        }
    }

    @inlinable
    public static func isAllUppercase<S: StringProtocol>(_ string: S) -> Bool {
        string.utf8.allSatisfy { byte in

            guard byte < 0x80 else { return true }
            return INCITS_4_1986.Classification.isLetter(byte)
                ? INCITS_4_1986.Classification.isUppercase(byte)
                : true
        }
    }
}
