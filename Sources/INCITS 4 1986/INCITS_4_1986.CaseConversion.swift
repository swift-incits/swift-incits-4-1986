extension INCITS_4_1986 {

    @inlinable
    public static func convert<C: Swift.Collection>(
        _ codes: C,
        to case: INCITS_4_1986.Case
    ) -> [ASCII_Primitives.ASCII.Code] where C.Element == ASCII_Primitives.ASCII.Code {
        ASCII_Primitives.ASCII.convert(codes, to: `case`)
    }

    @inlinable
    public static func convert<S: StringProtocol>(_ string: S, to case: INCITS_4_1986.Case) -> S {
        ASCII_Primitives.ASCII.convert(string, to: `case`)
    }
}
