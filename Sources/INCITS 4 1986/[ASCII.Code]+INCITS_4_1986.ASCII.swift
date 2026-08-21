import ASCII_Primitives_Standard_Library_Integration
import Standard_Library_Extensions

extension [ASCII_Primitives.ASCII.Code] {

    public static var ascii: ASCII.Type {
        ASCII.self
    }

    public enum ASCII {}
}

extension [ASCII_Primitives.ASCII.Code] {

    public init?(ascii s: some StringProtocol) {
        guard s.allSatisfy({ $0.isASCII }) else { return nil }
        self = s.utf8.map { ASCII_Primitives.ASCII.Code($0) }
    }

    public init(ascii lineEnding: INCITS_4_1986.FormatEffectors.Line.Ending) {
        switch lineEnding {
        case .lf: self = [ASCII_Primitives.ASCII.Code.lf]
        case .cr: self = [ASCII_Primitives.ASCII.Code.cr]
        case .crlf: self = [ASCII_Primitives.ASCII.Code].ascii.crlf
        }
    }
}

extension [ASCII_Primitives.ASCII.Code].ASCII {

    public static func unchecked(_ s: some StringProtocol) -> [ASCII_Primitives.ASCII.Code] {
        s.utf8.map { ASCII_Primitives.ASCII.Code($0) }
    }

    public static var crlf: [ASCII_Primitives.ASCII.Code] {
        [.cr, .lf]
    }

    public static var whitespaces: Set<ASCII_Primitives.ASCII.Code> {
        INCITS_4_1986.whitespaces
    }
}
