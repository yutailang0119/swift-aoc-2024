import Testing

@testable import AdventOfCode

struct Day06Tests {
  let testData = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...

    """

  @Test func testPart1() async throws {
    let challenge = Day06(data: testData)
    try await #expect(String(describing: challenge.part1()) == "41")
  }
}
