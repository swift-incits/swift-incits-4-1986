import Testing

import ASCII
import Byte
import Standard_Library_Extensions
@testable import INCITS_4_1986

@Suite
struct `ASCII space obeys its classification and value contracts` {

    @Suite
    struct `Space has the specified ASCII value and classifications` {
        @Test
        func `SPACE constant is 0x20`() {
            #expect(INCITS_4_1986.SPACE.sp == 0x20)
            #expect(ASCII::ASCII.Code.sp.underlying == 0x20)
        }

        @Test
        func `SPACE is recognized as whitespace`() {
            let sp = ASCII::ASCII.Code.sp
            #expect(sp.isWhitespace)
        }

        @Test
        func `SPACE is printable`() {
            let sp = ASCII::ASCII.Code.sp
            #expect(sp.isPrintable)
        }

        @Test
        func `SPACE is not a control character`() {
            let sp = ASCII::ASCII.Code.sp
            #expect(!sp.isControl)
        }

        @Test
        func `SPACE is not visible (visible = graphic characters only)`() {
            let sp = ASCII::ASCII.Code.sp
            #expect(!sp.isVisible, "SPACE is printable but not visible (visible = 0x21-0x7E)")
        }

        @Test
        func `The direct space constant agrees with the standard namespace`() {
            #expect(ASCII::ASCII.Code.sp.underlying == INCITS_4_1986.SPACE.sp)
        }
    }
}
