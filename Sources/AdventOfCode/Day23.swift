import Foundation

struct Day23: AdventDay {
  var data: String

  func part1() async throws -> Any {
    0
  }
}

private extension Day23 {
  var entities: [String] {
    data.split(separator: "\n").map(String.init)
  }

  var connections: [Connection] {
    let entities = self.entities

    return entities.map { entity in
      let splited = entity.split(separator: "-")
      return Connection(a: String(splited[0]), b: String(splited[1]))
    }
  }

  var computers: [String: Computer] {
    let connections = self.connections

    var computers: [String: Computer] = [:]
    for connection in connections {
      computers[
        connection.a,
        default: Computer(name: connection.a, connections: [])
      ].connections.insert(connection.b)
      computers[
        connection.b,
        default: Computer(name: connection.b, connections: [])
      ].connections.insert(connection.a)
    }

    return computers
  }
}

private extension Day23 {
  struct Connection {
    var a: String
    var b: String
  }

  struct Computer {
    var name: String
    var connections: Set<String>
  }
}
