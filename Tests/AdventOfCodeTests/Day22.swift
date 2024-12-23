import Testing

@testable import AdventOfCode

struct Day22Tests {
  @Test func testPart1() async throws {
    let testData = """
      1
      10
      100
      2024

      """
    let challenge = Day22(data: testData)
    try await #expect(String(describing: challenge.part1()) == "37327623")
  }

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

  @Test func testGenerate() async throws {
    do {
      let challenge = Day22(data: "")
      var secret = Day22.Secret(rawValue: 123)
      var numbers: [Int] = []
      for _ in 0..<10 {
        secret = challenge.generate(from: secret)
        numbers.append(secret.rawValue)
      }
      #expect(
        numbers == [
          15887950,
          16495136,
          527345,
          704524,
          1553684,
          12683156,
          11100544,
          12249484,
          7753432,
          5908254,
        ]
      )
    }
  }
}
