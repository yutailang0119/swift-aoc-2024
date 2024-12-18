import Testing

@testable import AdventOfCode

struct Day17Tests {
  @Test func testPart1() async throws {
    let testData = """
      Register A: 729
      Register B: 0
      Register C: 0

      Program: 0,1,5,4,3,0
      """
    let challenge = Day17(data: testData)
    try await #expect(String(describing: challenge.part1()) == "4,6,3,5,6,3,5,2,1,0")
  }

  @Test func testPart2() async throws {
    let testData = """
      Register A: 2024
      Register B: 0
      Register C: 0

      Program: 0,3,5,4,3,0
      """
    let challenge = Day17(data: testData)
    try await #expect(String(describing: challenge.part2()) == "117440")
  }
}