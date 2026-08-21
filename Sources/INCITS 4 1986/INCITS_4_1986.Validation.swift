extension INCITS_4_1986 {

    @_transparent
    public static func isASCII(_ byte: UInt8) -> Bool {
        ASCII_Primitives.ASCII.isASCII(byte)
    }

    @inlinable
    public static func isAllASCII<C: Swift.Collection>(
        _ bytes: C
    ) -> Bool where C.Element == UInt8 {
        ASCII_Primitives.ASCII.isAllASCII(bytes)
    }
}
