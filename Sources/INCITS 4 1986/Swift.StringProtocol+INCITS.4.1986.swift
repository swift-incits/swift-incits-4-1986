extension Swift.StringProtocol {
    public typealias ASCII = INCITS.`4`.`1986`.ASCII<Self>

    public static var ascii: ASCII.Type {
        ASCII.self
    }

    @inlinable
    public var ascii: ASCII {
        INCITS.`4`.`1986`.ASCII(self)
    }
}
