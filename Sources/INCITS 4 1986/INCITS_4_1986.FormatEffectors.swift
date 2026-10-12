extension INCITS_4_1986 {
    public enum FormatEffectors {}

    public static func normalized<C: Swift::Collection>(
        _ bytes: C,
        to lineEnding: FormatEffectors.Line.Ending
    ) -> [UInt8] where C.Element == UInt8 {
        ASCII::ASCII.normalized(bytes, to: lineEnding)
    }
}
