//
//  User.swift
//  App
//
//  Created by Jamaal Sedayao on 4/18/18.
//

import Foundation
import Vapor
import FluentSQLite

final class User: Codable {
    var id: UUID?
    var name: String
    var username: String

    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
}

extension User: SQLiteUUIDModel {}
extension User: Content {}
extension User: Migration {}
extension User: Parameter {}

extension User {
    var eventsHosted: Children<User, Event> {
        return children(\.hostID)
    }
}
