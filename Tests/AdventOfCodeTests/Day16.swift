import Testing

@testable import AdventOfCode

struct Day16Tests {
  let testDataFirst = """
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############

    """
  let testDataSecond = """
    #################
    #...#...#...#..E#
    #.#.#.#.#.#.#.#.#
    #.#.#.#...#...#.#
    #.#.#.#.###.#.#.#
    #...#.#.#.....#.#
    #.#.#.#.#.#####.#
    #.#...#.#.#.....#
    #.#.#####.#.###.#
    #.#.#.......#...#
    #.#.###.#####.###
    #.#.#...#.....#.#
    #.#.#.#####.###.#
    #.#.#.........#.#
    #.#.#.#########.#
    #S#.............#
    #################

    """

  @Test func testPart1() async throws {
    do {
      let challenge = Day16(data: testDataFirst)
      try await #expect(String(describing: challenge.part1()) == "7036")
    }
    do {
      let challenge = Day16(data: testDataSecond)
      try await #expect(String(describing: challenge.part1()) == "11048")
    }
  }

  @Test func testPart2() async throws {
    do {
      let challenge = Day16(data: testDataFirst)
      try await #expect(String(describing: challenge.part2()) == "45")
    }
    do {
      let challenge = Day16(data: testDataSecond)
      try await #expect(String(describing: challenge.part2()) == "64")
    }
  }
}
