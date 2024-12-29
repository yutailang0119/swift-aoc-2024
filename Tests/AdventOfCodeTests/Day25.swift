import Testing

@testable import AdventOfCode

struct Day25Tests {
  let testData = """
    #####
    .####
    .####
    .####
    .#.#.
    .#...
    .....

    #####
    ##.##
    .#.##
    ...##
    ...#.
    ...#.
    .....

    .....
    #....
    #....
    #...#
    #.#.#
    #.###
    #####

    .....
    .....
    #.#..
    ###..
    ###.#
    ###.#
    #####

    .....
    .....
    .....
    #....
    #.#..
    #.#.#
    #####

    """

  @Test func testPart1() async throws {
    let challenge = Day25(data: testData)
    try await #expect(String(describing: challenge.part1()) == "3")
  }
}
