import Standard_Library_Extensions

extension INCITS_4_1986.LineEnding {

    public enum Detection {}
}

extension INCITS_4_1986.LineEnding.Detection {

    @inlinable
    public static func detect<S: StringProtocol>(
        _ string: S
    ) -> INCITS_4_1986.FormatEffectors.Line.Ending? {

        let bytes = Array(string.utf8)
        var hasCR = false
        var hasLF = false

        var i = 0
        while i < bytes.count {
            let byte = bytes[i]
            if byte == INCITS_4_1986.Character.Control.cr {

                if i + 1 < bytes.count && bytes[i + 1] == INCITS_4_1986.Character.Control.lf {
                    return .crlf
                }
                hasCR = true
            } else if byte == INCITS_4_1986.Character.Control.lf {
                hasLF = true
            }
            i += 1
        }

        if hasCR { return .cr }
        if hasLF { return .lf }
        return nil
    }

    @inlinable
    public static func hasMixedLineEndings<S: StringProtocol>(_ string: S) -> Bool {
        let bytes = Array(string.utf8)
        var hasCRLF = false
        var hasStandaloneCR = false
        var hasStandaloneLF = false

        var i = 0
        while i < bytes.count {
            let byte = bytes[i]

            if byte == INCITS_4_1986.Character.Control.cr {

                if i + 1 < bytes.count && bytes[i + 1] == INCITS_4_1986.Character.Control.lf {
                    hasCRLF = true
                    i += 2
                    continue
                } else {
                    hasStandaloneCR = true
                    i += 1
                    continue
                }
            } else if byte == INCITS_4_1986.Character.Control.lf {
                hasStandaloneLF = true
                i += 1
                continue
            }

            i += 1
        }

        let typeCount = [hasCRLF, hasStandaloneCR, hasStandaloneLF].filter { $0 }.count
        return typeCount > 1
    }
}
