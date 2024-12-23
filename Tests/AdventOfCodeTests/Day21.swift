import Testing

@testable import AdventOfCode

struct Day21Tests {
  let testData = """
    029A
    980A
    179A
    456A
    379A

    """

  @Test func testPart1() async throws {
    let challenge = Day21(data: testData)
    try await #expect(String(describing: challenge.part1()) == "126384")
  }

  @Test func testPart2() async throws {
    let challenge = Day21(data: testData)
    try await #expect(String(describing: challenge.part2()) == "154115708116294")
  }
}
