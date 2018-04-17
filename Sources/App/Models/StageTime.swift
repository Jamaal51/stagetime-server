//
//  StageTime.swift
//  App
//
//  Created by Jamaal Sedayao on 4/17/18.
//

import Foundation
import FluentSQLite
import Vapor

final class StageTime: SQLiteModel {
    var id: Int?
    var title: String

    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

/// Allows `StageTime` to be used as a dynamic migration.
extension StageTime: Migration { }

/// Allows `StageTime` to be encoded to and decoded from HTTP messages.
extension StageTime: Content { }

/// Allows `StageTime` to be used as a dynamic parameter in route definitions.
extension StageTime: Parameter { }
