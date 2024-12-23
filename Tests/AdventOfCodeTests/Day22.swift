import Testing

@testable import AdventOfCode

struct Day22Tests {
  let testData = """
    1
    10
    100
    2024

    """

  @Test func testSecret() async throws {
    do {
      let secret = Day22.Secret(rawValue: 42)
      #expect(secret.mix(15).rawValue == 37)
    }
    do {
      let secret = Day22.Secret(rawValue: 100000000)
      #expect(secret.prune().rawValue == 16113920)
    }
  }

  @Test func testPart1() async throws {
    let challenge = Day22(data: testData)
    try await #expect(String(describing: challenge.part1()) == "37327623")
  }
}
