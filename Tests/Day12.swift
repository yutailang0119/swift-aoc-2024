import Testing

@testable import AdventOfCode

struct Day12Tests {
  @Test func testPart1() async throws {
    do {
      let testData = """
        AAAA
        BBCD
        BBCC
        EEEC

        """
      let challenge = Day12(data: testData)
      try await #expect(String(describing: challenge.part1()) == "140")
    }
    do {
      let testData = """
        OOOOO
        OXOXO
        OOOOO
        OXOXO
        OOOOO

        """
      let challenge = Day12(data: testData)
      try await #expect(String(describing: challenge.part1()) == "772")
    }
    do {
      let testData = """
        RRRRIICCFF
        RRRRIICCCF
        VVRRRCCFFF
        VVRCCCJFFF
        VVVVCJJCFE
        VVIVCCJJEE
        VVIIICJJEE
        MIIIIIJJEE
        MIIISIJEEE
        MMMISSJEEE

        """
      let challenge = Day12(data: testData)
      try await #expect(String(describing: challenge.part1()) == "1930")
    }
  }

  @Test func testPart2() async throws {
    do {
      let testData = """
        AAAA
        BBCD
        BBCC
        EEEC

        """
      let challenge = Day12(data: testData)
      try await #expect(String(describing: challenge.part2()) == "80")
    }
    do {
      let testData = """
        OOOOO
        OXOXO
        OOOOO
        OXOXO
        OOOOO

        """
      let challenge = Day12(data: testData)
      try await #expect(String(describing: challenge.part2()) == "436")
    }
    do {
      let testData = """
        EEEEE
        EXXXX
        EEEEE
        EXXXX
        EEEEE

        """
      let challenge = Day12(data: testData)
      try await #expect(String(describing: challenge.part2()) == "236")
    }
    do {
      let testData = """
        AAAAAA
        AAABBA
        AAABBA
        ABBAAA
        ABBAAA
        AAAAAA

        """
      let challenge = Day12(data: testData)
      try await #expect(String(describing: challenge.part2()) == "368")
    }
    do {
      let testData = """
        RRRRIICCFF
        RRRRIICCCF
        VVRRRCCFFF
        VVRCCCJFFF
        VVVVCJJCFE
        VVIVCCJJEE
        VVIIICJJEE
        MIIIIIJJEE
        MIIISIJEEE
        MMMISSJEEE

        """
      let challenge = Day12(data: testData)
      try await #expect(String(describing: challenge.part2()) == "1206")
    }
  }
}
