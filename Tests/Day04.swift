import Testing

@testable import AdventOfCode

struct Day04Tests {
  let testData = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX

    """

  @Test func testPart1() async throws {
    let challenge = Day04(data: testData)
    try await #expect(String(describing: challenge.part1()) == "18")
  }
}