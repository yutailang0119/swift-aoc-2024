import Foundation

public struct Table<Element>: Sendable where Element: Sendable, Element: Equatable {
  public var lines: [[Element]]

  public init(_ lines: [[Element]]) {
    self.lines = lines
  }
}

extension Table: CustomStringConvertible where Element: CustomStringConvertible {
  public var description: String {
    lines.map { $0.map(\.description).joined() }
      .joined(separator: "\n")
  }
}

public extension Table {
  var count: Int {
    lines.reduce(0) { $0 + $1.count }
  }

  func element(at position: Position) -> Element? {
    lines[safe: position.y]?[safe: position.x]
  }

  func elements(from start: Position, to direction: Direction) -> [Element] {
    var elements: [Element] = []
    var cursor: Position? = start
    while let c = cursor {
      let next = c.moved(to: direction)
      if let element = element(at: next) {
        elements.append(element)
        cursor = next
      } else {
        cursor = nil
      }
    }
    return elements
  }

  func route(from start: Position, to direction: Direction, until element: Element? = nil) -> [Position] {
    var positions: [Position] = []
    var p = start
    var next = self.element(at: p.moved(to: direction))
    while next != nil, next != element {
      positions.append(p)
      p = p.moved(to: direction)
      next = self.element(at: p)
    }
    return positions
  }

  func positions(for element: Element) -> [Position] {
    var positions: [Position] = []
    for line in lines.enumerated() {
      for e in line.element.enumerated() {
        if e.element == element {
          positions.append(Position(x: e.offset, y: line.offset))
        }
      }
    }
    return positions
  }

  var positions: [[(Element, Position)]] {
    lines.enumerated().reduce(into: [[(Element, Position)]]()) { lns, y in
      lns.append(
        y.element.enumerated().map {
          ($0.element, Position(x: $0.offset, y: y.offset))
        }
      )
    }
  }
}

public extension Table {
  mutating func swap(_ i: Position, _ j: Position) {
    guard let ie = element(at: i),
      let je = element(at: j)
    else {
      return
    }
    lines[i.y][i.x] = je
    lines[j.y][j.x] = ie
  }
}