import Testing

import ASCII
import Byte
import Standard_Library_Extensions
@testable import INCITS_4_1986

private func isAllASCII(_ bytes: [Byte]) -> Bool {
    bytes.allSatisfy { (try? ASCII.Code($0)) != nil }
}

@Suite
struct `Byte and code arrays expose ASCII operations` {
    @Suite
    struct `Arrays validate convert and classify ASCII values` {
        @Test
        func `Byte array has validation method`() {
            let ascii: [Byte] = [Byte(0x48), Byte(0x65), Byte(0x6C), Byte(0x6C), Byte(0x6F)]
            #expect(isAllASCII(ascii))

            let nonAscii: [Byte] = [Byte(0x48), Byte(0xFF)]
            #expect(!isAllASCII(nonAscii))
        }

        @Test
        func `Byte array has case conversion method`() {
            let codes: [ASCII.Code] = [.H, .e, .l, .l, .o]
            let upper = codes.ascii(case: .upper)
            #expect(upper == [.H, .E, .L, .L, .O])
        }

        @Test
        func `Byte array has line ending conversion`() {
            let lf = [ASCII.Code](ascii: .lf)
            #expect(lf == [.lf])

            let crlf = [ASCII.Code](ascii: .crlf)
            #expect(crlf == [.cr, .lf])
        }

        @Test
        func `Byte array has string conversion`() {
            let codes: [ASCII.Code] = [.H, .e, .l, .l, .o]
            #expect([ASCII.Code](ascii: "Hello") == codes)
        }

        @Test
        func `Byte array has whitespaces constant`() {

            let ws = [ASCII.Code].ascii.whitespaces
            #expect(ws.contains(.sp))
            #expect(ws.contains(.htab))
            #expect(ws.contains(.lf))
            #expect(ws.contains(.cr))
        }
    }
}
