// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-incits-4-1986 open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-incits-4-1986 project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Testing

@testable import INCITS_4_1986

extension INCITS_4_1986.LineEnding.Detection {
    @Suite struct `Line Ending Detection Tests` {
        @Suite struct Unit {
            @Test func `detect identifies LF only text`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("line1\nline2") == .lf)
            }

            @Test func `detect identifies CR only text`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("line1\rline2") == .cr)
            }

            @Test func `detect identifies CRLF text`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("line1\r\nline2") == .crlf)
            }

            @Test func `detect returns nil when no line endings are present`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("no line endings") == nil)
            }

            @Test func `hasMixedLineEndings is false for a single consistent style`() {
                #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("line1\nline2\nline3"))
                #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("line1\r\nline2\r\nline3"))
            }

            @Test func `hasMixedLineEndings is true when multiple styles are present`() {
                #expect(INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("line1\nline2\r\nline3"))
                #expect(INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("line1\rline2\nline3"))
            }
        }

        @Suite struct `Edge Case` {
            @Test func `detect on an empty string returns nil`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("") == nil)
            }

            @Test func `detect prioritizes CRLF when CR is immediately followed by LF`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("\r\n") == .crlf)
            }

            @Test func `detect treats a trailing standalone CR as CR not CRLF`() {
                #expect(INCITS_4_1986.LineEnding.Detection.detect("line1\r") == .cr)
            }

            @Test func `hasMixedLineEndings is false on an empty string`() {
                #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings(""))
            }

            @Test func `hasMixedLineEndings is false for a single line ending occurrence`() {
                #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("\n"))
            }

            @Test func `hasMixedLineEndings treats repeated CRLF as one style not two`() {
                #expect(!INCITS_4_1986.LineEnding.Detection.hasMixedLineEndings("a\r\nb\r\nc\r\n"))
            }
        }

        @Suite struct Integration {}
    }
}
