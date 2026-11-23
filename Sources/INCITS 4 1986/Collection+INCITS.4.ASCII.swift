extension Swift::Collection where Element == ASCII::ASCII.Code {

    @inlinable
    public var ascii: INCITS.`4`.ASCII<Self> {
        INCITS.`4`.ASCII(self)
    }
}
