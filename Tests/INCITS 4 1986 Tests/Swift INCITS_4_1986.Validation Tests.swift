import Testing

import ASCII
import Byte
import Standard_Library_Extensions
@testable import INCITS_4_1986

@Suite
struct `ASCII validation rejects every byte outside the seven bit range` {

    @Suite
    struct `Byte collections validate every member before conversion` {
        @Test
        func `Valid ASCII bytes convert to codes`() throws {
            let bytes: [Byte] = [0x00, 0x41, 0x7F]
            let _: [ASCII.Code] = try bytes.map { try ASCII.Code($0) }
        }

        @Test
        func `Invalid ASCII bytes fail conversion to codes`() {
            let bytes: [Byte] = [0x41, 0x80, 0xFF]
            #expect(throws: ASCII.Code.Error.self) {
                let _: [ASCII.Code] = try bytes.map { try ASCII.Code($0) }
            }
        }

        @Test
        func `Empty array is valid ASCII`() throws {
            let codes: [ASCII.Code] = try ([] as [Byte]).map { try ASCII.Code($0) }
            #expect(codes.isEmpty)
        }

        @Test
        func `Code conversion accepts the ASCII boundaries and rejects the next byte`() throws {
            let _: [ASCII.Code] = try ([0x00] as [Byte]).map { try ASCII.Code($0) }
            let _: [ASCII.Code] = try ([0x7F] as [Byte]).map { try ASCII.Code($0) }
            #expect(throws: ASCII.Code.Error.self) {
                let _: [ASCII.Code] = try ([0x80] as [Byte]).map { try ASCII.Code($0) }
            }
        }
    }

    @Suite
    struct `Byte validation accepts exactly the ASCII range` {
        @Test(arguments: [0x00, 0x01, 0x7E, 0x7F] as [Byte])
        func `Valid ASCII bytes convert to codes`(byte: Byte) throws {
            let _: ASCII.Code = try ASCII.Code(byte)
        }

        @Test(arguments: [0x80, 0x81, 0xFE, 0xFF] as [Byte])
        func `Invalid ASCII bytes fail conversion to codes`(byte: Byte) {
            #expect(throws: ASCII.Code.Error.notASCII(byte: byte)) {
                let _: ASCII.Code = try ASCII.Code(byte)
            }
        }

        @Test
        func `All valid ASCII bytes pass validation`() throws {

            let allASCII = (UInt8(0)...UInt8(127)).map(Byte.init(bitPattern:))
            let _: [ASCII.Code] = try allASCII.map { try ASCII.Code($0) }
        }

        @Test
        func `Any non-ASCII byte fails validation`() {
            for value in UInt8(128)...UInt8(255) {
                let mixed: [Byte] = [0x41, Byte(bitPattern: value), 0x42]
                #expect(throws: ASCII.Code.Error.self) {
                    let _: [ASCII.Code] = try mixed.map { try ASCII.Code($0) }
                }
            }
        }
    }
}
