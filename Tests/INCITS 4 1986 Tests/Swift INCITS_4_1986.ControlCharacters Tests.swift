import Testing

import ASCII
import Byte
import Standard_Library_Extensions
@testable import INCITS_4_1986

@Suite
struct `ASCII exposes the specified control character constants` {
    @Suite
    struct `Control constants have the specified numeric values` {
        @Test
        func `The NUL constant has its specified value`() {
            #expect(ASCII::ASCII.Code.nul.underlying == 0x00)
        }

        @Test
        func `The HTAB constant has its specified value`() {
            #expect(ASCII::ASCII.Code.htab.underlying == 0x09)
        }

        @Test
        func `The LF constant has its specified value`() {
            #expect(ASCII::ASCII.Code.lf.underlying == 0x0A)
        }

        @Test
        func `The CR constant has its specified value`() {
            #expect(ASCII::ASCII.Code.cr.underlying == 0x0D)
        }

        @Test
        func `The DELETE constant has its specified value`() {
            #expect(ASCII::ASCII.Code.del.underlying == 0x7F)
        }
    }

    @Suite
    struct `All ASCII control characters are accessible` {
        @Test(arguments: [
            (0x00, "nul"), (0x01, "soh"), (0x02, "stx"), (0x03, "etx"),
            (0x04, "eot"), (0x05, "enq"), (0x06, "ack"), (0x07, "bel"),
            (0x08, "bs"), (0x09, "htab"), (0x0A, "lf"), (0x0B, "vtab"),
            (0x0C, "ff"), (0x0D, "cr"), (0x0E, "so"), (0x0F, "si"),
            (0x10, "dle"), (0x11, "dc1"), (0x12, "dc2"), (0x13, "dc3"),
            (0x14, "dc4"), (0x15, "nak"), (0x16, "syn"), (0x17, "etb"),
            (0x18, "can"), (0x19, "em"), (0x1A, "sub"), (0x1B, "esc"),
            (0x1C, "fs"), (0x1D, "gs"), (0x1E, "rs"), (0x1F, "us"),
            (0x7F, "del"),
        ])
        func `All control character constants are accessible`(value: UInt8, name: String) {
            #expect(value <= 0x1F || value == 0x7F, "\(name) should be a control character")
        }

        @Test
        func `All thirty three control characters have their specified values`() {

            #expect(ASCII::ASCII.Code.nul.underlying == 0x00)
            #expect(ASCII::ASCII.Code.soh.underlying == 0x01)
            #expect(ASCII::ASCII.Code.stx.underlying == 0x02)
            #expect(ASCII::ASCII.Code.etx.underlying == 0x03)
            #expect(ASCII::ASCII.Code.eot.underlying == 0x04)
            #expect(ASCII::ASCII.Code.enq.underlying == 0x05)
            #expect(ASCII::ASCII.Code.ack.underlying == 0x06)
            #expect(ASCII::ASCII.Code.bel.underlying == 0x07)
            #expect(ASCII::ASCII.Code.bs.underlying == 0x08)
            #expect(ASCII::ASCII.Code.htab.underlying == 0x09)
            #expect(ASCII::ASCII.Code.lf.underlying == 0x0A)
            #expect(ASCII::ASCII.Code.vtab.underlying == 0x0B)
            #expect(ASCII::ASCII.Code.ff.underlying == 0x0C)
            #expect(ASCII::ASCII.Code.cr.underlying == 0x0D)
            #expect(ASCII::ASCII.Code.so.underlying == 0x0E)
            #expect(ASCII::ASCII.Code.si.underlying == 0x0F)
            #expect(ASCII::ASCII.Code.dle.underlying == 0x10)
            #expect(ASCII::ASCII.Code.dc1.underlying == 0x11)
            #expect(ASCII::ASCII.Code.dc2.underlying == 0x12)
            #expect(ASCII::ASCII.Code.dc3.underlying == 0x13)
            #expect(ASCII::ASCII.Code.dc4.underlying == 0x14)
            #expect(ASCII::ASCII.Code.nak.underlying == 0x15)
            #expect(ASCII::ASCII.Code.syn.underlying == 0x16)
            #expect(ASCII::ASCII.Code.etb.underlying == 0x17)
            #expect(ASCII::ASCII.Code.can.underlying == 0x18)
            #expect(ASCII::ASCII.Code.em.underlying == 0x19)
            #expect(ASCII::ASCII.Code.sub.underlying == 0x1A)
            #expect(ASCII::ASCII.Code.esc.underlying == 0x1B)
            #expect(ASCII::ASCII.Code.fs.underlying == 0x1C)
            #expect(ASCII::ASCII.Code.gs.underlying == 0x1D)
            #expect(ASCII::ASCII.Code.rs.underlying == 0x1E)
            #expect(ASCII::ASCII.Code.us.underlying == 0x1F)

            #expect(ASCII::ASCII.Code.del.underlying == 0x7F)
        }

        @Test
        func `The control predicate recognizes every control character`() {
            let controlChars: [UInt8] = [
                ASCII::ASCII.Code.nul.underlying, ASCII::ASCII.Code.htab.underlying, ASCII::ASCII.Code.lf.underlying,
                ASCII::ASCII.Code.cr.underlying, ASCII::ASCII.Code.esc.underlying, ASCII::ASCII.Code.del.underlying,
            ]
            for byte in controlChars {
                #expect(byte.ascii.isControl, "0x\(String(byte, radix: 16)) should be control")
            }
        }

        @Test
        func `Control constants agree with the standard namespace`() {

            #expect(ASCII::ASCII.Code.nul.underlying == INCITS_4_1986.Character.Control.nul)
            #expect(ASCII::ASCII.Code.lf.underlying == INCITS_4_1986.Character.Control.lf)
            #expect(ASCII::ASCII.Code.cr.underlying == INCITS_4_1986.Character.Control.cr)
            #expect(ASCII::ASCII.Code.del.underlying == INCITS_4_1986.Character.Control.del)
        }
    }
}
