extension INCITS.`4` {

    @inlinable
    public static func convert<C: Swift::Collection>(
        _ codes: C,
        to case: INCITS.`4`.Case
    ) -> [ASCII::ASCII.Code] where C.Element == ASCII::ASCII.Code {
        ASCII::ASCII.convert(codes, to: `case`)
    }

    @inlinable
    public static func convert<S: StringProtocol>(_ string: S, to case: INCITS.`4`.Case) -> S {
        ASCII::ASCII.convert(string, to: `case`)
    }
}
