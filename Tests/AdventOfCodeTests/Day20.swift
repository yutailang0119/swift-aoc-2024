import Testing

@testable import AdventOfCode

struct Day20Tests {
  let testData = """
    ###############
    #...#...#.....#
    #.#.#.#.#.###.#
    #S#...#.#.#...#
    #######.#.#.###
    #######.#.#...#
    #######.#.###.#
    ###..E#...#...#
    ###.#######.###
    #...###...#...#
    #.#####.#.###.#
    #.#...#.#.#...#
    #.#.#.#.#.#.###
    #...#...#...###
    ###############

    """

  @Test func testPart1() async throws {
    let challenge = Day20(data: testData)
    #expect(String(describing: challenge._part1(cheatingRule: 2, lower: 2)) == "44")
  }

  @Test func testPart2() async throws {
    let challenge = Day20(data: testData)
    #expect(String(describing: challenge._part2(cheatingRule: 20, lower: 50)) == "285")
  }
}
