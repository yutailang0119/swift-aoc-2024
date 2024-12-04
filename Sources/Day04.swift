import Foundation

struct Day04: AdventDay {
  var data: String

  var entities: [[String]] {
    data.split(separator: "\n")
      .map { $0.map(String.init) }
  }

  func part1() async throws -> Any {
    0
  }
}

private extension Day04 {
  enum Word: String {
    case x = "X"
    case m = "M"
    case a = "A"
    case s = "S"

    var next: Word? {
      switch self {
      case .x: return .m
      case .m: return .a
      case .a: return .s
      case .s: return nil
      }
    }
  }

  struct Cursor {
    var word: Word
    var position: Puzzle.Position
  }
}
