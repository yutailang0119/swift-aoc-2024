import Foundation
import ToolKit

struct Day04: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let lines = entities.map { $0.compactMap(Word.init(rawValue:)) }
    let table = Table<Word>(lines: lines)

    let directions: [Direction] = [
      .top,
      .bottom,
      .left,
      .right,
      [.top, .left],
      [.top, .right],
      [.bottom, .left],
      [.bottom, .right],
    ]

    var count = 0
    for x in table.positions(for: .x) {
      for direction in directions {
        var cursor: Cursor? = Cursor(word: .x, position: x)
        while let c = cursor {
          guard let nextWord = c.word.next else {
            count += 1
            cursor = nil
            break
          }
          let nextPosition = c.position.moved(to: direction)
          if nextWord == table.element(at: nextPosition) {
            cursor = Cursor(word: nextWord, position: nextPosition)
          } else {
            cursor = nil
          }
        }
      }
    }
    return count
  }

  func part2() async throws -> Any {
    let lines = entities.map { $0.compactMap(Word.init(rawValue:)) }
    let table = Table<Word>(lines: lines)

    var count = 0
    for a in table.positions(for: .a) {
      let mas1 = Set([
        table.element(at: a.moved(to: [.top, .left])),
        table.element(at: a),
        table.element(at: a.moved(to: [.bottom, .right])),
      ])
      let mas2 = Set([
        table.element(at: a.moved(to: [.top, .right])),
        table.element(at: a),
        table.element(at: a.moved(to: [.bottom, .left])),
      ])
      let expected = Set<Word>([.m, .a, .s])
      if mas1 == expected,
        mas2 == expected
      {
        count += 1
      }
    }
    return count
  }
}

private extension Day04 {
  var entities: [[String]] {
    data.split(separator: "\n")
      .map { $0.map(String.init) }
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
    var position: Position
  }
}
