import Testing

@testable import AdventOfCode

struct Day11Tests {
  let testData = """
    125 17

    """

  @Test func testPart1() async throws {
    let challenge = Day11(data: testData)
    try await #expect(String(describing: challenge.part1()) == "55312")
  }
}
