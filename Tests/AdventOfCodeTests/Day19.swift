import Testing

@testable import AdventOfCode

struct Day19Tests {
  let testData = """
    r, wr, b, g, bwu, rb, gb, br

    brwrr
    bggr
    gbbr
    rrbgbr
    ubwu
    bwurrg
    brgr
    bbrgwb

    """

  @Test func testPart1() async throws {
    let challenge = Day19(data: testData)
    try await #expect(String(describing: challenge.part1()) == "6")
  }
}
