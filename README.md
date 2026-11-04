# swift-incits-4-1986

Use this package when you want US-ASCII operations, named after INCITS 4-1986, on Swift strings, substrings and arrays of `ASCII.Code`: checking that text is ASCII, classifying it, changing the case of its letters, detecting its line endings and splitting it into lines. Start from `INCITS_4_1986.ASCII`, which you reach through the `ascii` member of a string, a substring or a collection of `ASCII.Code`. If you work with single bytes, or need number parsing or line ending normalization on its own, use swift-ascii, which this package builds on.

## Laws

- A string predicate looks at the string's UTF-8 bytes. Any character outside ASCII makes `INCITS_4_1986.ASCII.isAllLetters` and the other `isAll` predicates false, except `INCITS_4_1986.ASCII.isAllLowercase` and `INCITS_4_1986.ASCII.isAllUppercase`. Those two look only at ASCII letters, so `café` is all lowercase and `123` is both.
- Every `isAll` predicate holds for empty input. `INCITS_4_1986.ASCII.containsHexDigit` does not.
- Case conversion of a string changes only A to Z and a to z. Every other character, including non-ASCII ones, comes back unchanged.
- `INCITS_4_1986.ASCII.detectedLineEnding()` reports CRLF if a CR is followed by LF anywhere in the text. Otherwise it reports CR if there is a lone CR, then LF if there is an LF, and nil when there is no line ending.
- `INCITS_4_1986.ASCII.containsMixedLineEndings` treats CRLF, a lone CR and a lone LF as three different styles, and is true when more than one of them occurs.
- `INCITS_4_1986.ASCII.lineRanges(estimatedLineCount:)` ends a line at CRLF, a lone CR or a lone LF, and leaves the line ending out of the range. A line ending at the very end does not start an empty last line, and empty input has no lines.
- `INCITS_4_1986.ASCII.elementsEqualCaseInsensitive(_:)` and `INCITS_4_1986.ASCII.hasPrefix(caseInsensitive:)` fold only ASCII letters.
- `Set<Character>.ASCII.whitespaces` holds SPACE, HT, LF and CR, and also the CRLF pair, because Swift treats CRLF as a single `Character`. VT, FF and non-ASCII spaces are not whitespace.
- Converting text to `ASCII.Code` values fails with nil if any character is outside ASCII. The `unchecked` conversions do not check.
