import Foundation
import FluentMySQL
import Vapor

final class Event: MySQLUUIDModel {
    var id: UUID?
    var title: String
    var type: String
    var stageTime: Int
    var hostID: User.ID

    init(title: String, type: String, stageTime: Int, hostID: User.ID) {
        self.title = title
        self.type = type
        self.stageTime = stageTime
        self.hostID = hostID
    }
}

/// Allows `Event` to be used as a dynamic migration.
extension Event: Migration { }

/// Allows `Event` to be encoded to and decoded from HTTP messages.
extension Event: Content { }

/// Allows `Event` to be used as a dynamic parameter in route definitions.
extension Event: Parameter { }

extension Event {
    var host: Parent<Event, User> {
        return parent(\.hostID)
    }
}
