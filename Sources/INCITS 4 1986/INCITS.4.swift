public import INCITS

extension INCITS {
    public enum `4` {}
}

extension INCITS.`4` {

    public typealias Case = ASCII::ASCII.Case
}

extension INCITS.`4` {

    public static var whitespaces: Set<ASCII::ASCII.Code> {
        ASCII::ASCII.whitespaces
    }
}
