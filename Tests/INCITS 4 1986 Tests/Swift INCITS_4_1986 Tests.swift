import ASCII
import Byte
import Standard_Library_Extensions
import Testing

@testable import INCITS_4_1986

@Suite
struct `INCITS exposes ASCII whitespace and case constants` {
    @Test
    func `Whitespaces set contains exactly 4 characters`() {
        #expect(INCITS_4_1986.whitespaces.count == 4)
    }

    @Test
    func `Whitespaces contains SPACE, TAB, LF, CR`() {
        #expect(INCITS_4_1986.whitespaces.contains(ASCII::ASCII.Code.sp))
        #expect(INCITS_4_1986.whitespaces.contains(ASCII::ASCII.Code.htab))
        #expect(INCITS_4_1986.whitespaces.contains(ASCII::ASCII.Code.lf))
        #expect(INCITS_4_1986.whitespaces.contains(ASCII::ASCII.Code.cr))
    }

    @Test
    func `CRLF sequence is correct`() {
        #expect(INCITS_4_1986.Character.Control.crlf == [ASCII::ASCII.Code.cr.underlying, ASCII::ASCII.Code.lf.underlying])
    }

    @Test
    func `Case conversion offset is 0x20`() {
        #expect(INCITS_4_1986.Case.Conversion.offset == ASCII::ASCII.Code.sp.underlying)
        #expect(INCITS_4_1986.Case.Conversion.offset == 32)
    }

    @Test
    func `Case conversion offset matches letter distance`() {

        #expect(
            ASCII.Code.a.underlying &- ASCII.Code.A.underlying
                == INCITS_4_1986.Case.Conversion.offset
        )
    }
}
