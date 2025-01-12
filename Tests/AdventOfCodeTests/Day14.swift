import Testing

@testable import AdventOfCode

struct Day14Tests {
  let testData = """
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3

    """

  @Test func testPart1() async throws {
    do {
      let challenge = Day14(data: testData)
      #expect(String(describing: challenge._part1(after: 100, in: Day14.Space(wide: 11, tall: 7))) == "12")
    }
    do {
      let challenge = Day14(data: testData)
      try await #expect(String(describing: challenge.part1()) == "21")
    }
  }

  @Test func testPart2() async throws {
    let challenge = Day14(data: testData)
    #expect(String(describing: challenge._part2(in: Day14.Space(wide: 11, tall: 7))) == "63")
  }
}
