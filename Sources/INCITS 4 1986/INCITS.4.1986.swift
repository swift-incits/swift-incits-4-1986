public import INCITS

extension INCITS.`4` {
    public enum `1986` {}
}

extension INCITS.`4`.`1986` {

    public typealias Case = ASCII::ASCII.Case
}

extension INCITS.`4`.`1986` {

    public static var whitespaces: Set<ASCII::ASCII.Code> {
        ASCII::ASCII.whitespaces
    }
}
