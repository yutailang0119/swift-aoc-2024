import Foundation

struct Day09: AdventDay {
  var data: String

  func part1() async throws -> Any {
    let blocks: [Block] = entities.chunks(ofCount: 2).enumerated()
      .reduce(into: []) { blocks, enumerated in
        let chunk = Array(enumerated.element)
        if let file = chunk[safe: 0] {
          if enumerated.offset == 0 {
            blocks.append(contentsOf: Array(repeating: .zero(count: 1), count: file))
          } else {
            blocks.append(contentsOf: Array(repeating: Block.number(Int(enumerated.offset), count: 1), count: file))
          }
        }
        if let space = chunk[safe: 1] {
          blocks.append(contentsOf: Array(repeating: Block.space(count: 1), count: space))
        }
      }
    var diskMap = DiskMap(blocks: blocks)

    var swapped: [Block] = diskMap.blocks
    for (offset, block) in swapped.enumerated() {
      if block.isSpace {
        if let lastIndex = swapped.lastIndex(where: { !$0.isSpace }) {
          swapped.swapAt(offset, lastIndex)
        }
      }
      if swapped.suffix(from: offset + 1).allSatisfy(\.isSpace) {
        break
      }
    }
    diskMap.blocks = swapped

    return diskMap.checksum
  }

  func part2() async throws -> Any {
    let blocks: [Block] = entities.chunks(ofCount: 2).enumerated()
      .reduce(into: []) { blocks, enumerated in
        let chunk = Array(enumerated.element)
        if let file = chunk[safe: 0] {
          if enumerated.offset == 0 {
            blocks.append(.zero(count: file))
          } else {
            blocks.append(.number(enumerated.offset, count: file))
          }
        }
        if let space = chunk[safe: 1] {
          blocks.append(.space(count: space))
        }
      }
    var diskMap = DiskMap(blocks: blocks)

    var swapped: [Block] = diskMap.blocks
    for block in diskMap.blocks.reversed() {
      guard case .number(let num, let count) = block else { continue }
      var index: Int?
      var remaining: Int?
      for (offset, s) in swapped.enumerated() {
        if case .space(let c) = s {
          if c >= count {
            index = offset
            remaining = c - count
            break
          }
        }
      }

      if let index,
        let remaining, remaining >= 0
      {
        swapped[index] = .number(num, count: count)
        swapped.insert(.space(count: remaining), at: index + 1)
        if let lastIndex = swapped.lastIndex(where: { $0 == block }) {
          swapped[lastIndex] = .space(count: count)
        }
      }
    }
    diskMap.blocks = swapped

    return diskMap.checksum
  }
}

private extension Day09 {
  var entities: [Int] {
    data.compactMap { Int(String($0)) }
  }
}

private extension Day09 {
  struct DiskMap: CustomStringConvertible {
    var blocks: [Block]

    var checksum: Int {
      var checksum = 0
      let nums = blocks.flatMap(\.nums)
      for (offset, num) in nums.enumerated() {
        checksum += offset * num
      }
      return checksum
    }

    var description: String {
      blocks.map(\.description).joined()
    }
  }

  enum Block: Equatable, CustomStringConvertible {
    case zero(count: Int)
    case number(Int, count: Int)
    case space(count: Int)

    var isSpace: Bool {
      switch self {
      case .zero: return false
      case .number: return false
      case .space: return true
      }
    }

    var nums: [Int] {
      switch self {
      case .zero(let count):
        return Array(repeating: 0, count: count)
      case .number(let num, let count):
        return Array(repeating: num, count: count)
      case .space(let count):
        return Array(repeating: 0, count: count)
      }
    }

    var description: String {
      switch self {
      case .zero(let count):
        return Array(repeating: "0", count: count).joined()
      case .number(let num, let count):
        return Array(repeating: "\(num)", count: count).joined()
      case .space(let count):
        return Array(repeating: ".", count: count).joined()
      }
    }
  }
}
